#!/usr/bin/env bash
set -euo pipefail

if [[ $(id -u) == 0 ]]; then
   echo "This script must NOT be run as root"
   exit 1
fi

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ -f $DIR/init-precheck.sh ]]; then
    $DIR/init-precheck.sh
fi

# Defaults
removeTaint=false
cni=""

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --remove-taint)
            removeTaint=true
            shift
            ;;
        --cni)
            cni="$2"
            shift 2
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

if [[ -z ${cni:-} ]]; then
    if [[ -f /opt/iximiuz-labs/init-conditions.json ]]; then
        cni=$(jq -r '."Network addon" // "flannel"' /opt/iximiuz-labs/init-conditions.json)
    else
        cni="none"

        echo "WARNING: Cannot determine network addon, using none"
    fi
fi

if [[ -f $DIR/prepare.sh ]]; then
    $DIR/prepare.sh
fi

if [[ "$(systemctl --wait show -p Result --value image-loader.service)" != "success" ]]; then
    echo "WARNING: Image loading failed"
fi

sudo kubeadm init \
    --config $DIR/kubeadm.yaml \
    --ignore-preflight-errors NumCPU,Mem \
    --skip-token-print \
    --skip-phases show-join-command

$DIR/kubeconfig.sh
$DIR/install-cni.sh $cni

if [[ $removeTaint = true ]]; then
    kubectl taint nodes --all node-role.kubernetes.io/control-plane:NoSchedule-
else
    echo ""
    echo ""
    echo "If you want to schedule pods on the control plane node,"
    echo "remove the NoSchedule taint with the following command:"
    echo ""
    echo "kubectl taint nodes --all node-role.kubernetes.io/control-plane:NoSchedule-"
fi

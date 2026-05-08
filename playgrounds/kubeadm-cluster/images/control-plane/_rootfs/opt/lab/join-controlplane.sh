#!/usr/bin/env bash
set -euo pipefail

if [[ $(id -u) == 0 ]]; then
   echo "This script must NOT be run as root"
   exit 1
fi

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Defaults
removeTaint=false

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --remove-taint)
            removeTaint=true
            shift
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

if [[ -f $DIR/prepare.sh ]]; then
    $DIR/prepare.sh
fi

if [[ "$(systemctl --wait show -p Result --value image-loader.service)" != "success" ]]; then
    echo "WARNING: Image loading failed"
fi

if [[ -z ${KUBE_CPLANE_HOST:-} ]]; then
    KUBE_CPLANE_HOST="control-plane"
fi

# https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/high-availability/#manual-certs
sudo mkdir -p /etc/kubernetes/pki/{,etcd}
sudo scp -o StrictHostKeyChecking=no ${KUBE_CPLANE_HOST?}:/etc/kubernetes/pki/{*ca.crt,*ca.key,sa.*} /etc/kubernetes/pki
sudo scp -o StrictHostKeyChecking=no ${KUBE_CPLANE_HOST?}:/etc/kubernetes/pki/etcd/ca.{crt,key} /etc/kubernetes/pki/etcd
sudo scp -o StrictHostKeyChecking=no ${KUBE_CPLANE_HOST?}:/etc/kubernetes/admin.conf /etc/kubernetes

token=$(sudo ssh ${KUBE_CPLANE_HOST?} kubeadm token create)
caCertHash=$(openssl x509 -pubkey -in /etc/kubernetes/pki/ca.crt | openssl rsa -pubin -outform der 2>/dev/null | openssl dgst -sha256 -hex | sed 's/^.* //')

configFile=$(mktemp)

sudo touch /opt/lab/kubeadm.yaml
cat /opt/lab/kubeadm.yaml - <<EOF | yq -o json | jq -s 'group_by(.kind) | map(reduce .[] as $item ({}; . * $item)) | .[]' | yq -p json -o yaml > $configFile

---
apiVersion: kubeadm.k8s.io/v1beta4
kind: JoinConfiguration
discovery:
  bootstrapToken:
    apiServerEndpoint: ${KUBE_CPLANE_HOST?}:6443
    token: ${token}
    caCertHashes: ["sha256:${caCertHash}"]
  tlsBootstrapToken: ${token}

---
apiVersion: kubeadm.k8s.io/v1beta4
kind: JoinConfiguration
controlPlane: {}
EOF

sudo kubeadm join ${KUBE_CPLANE_HOST?}:6443 --config $configFile --ignore-preflight-errors NumCPU,Mem
sleep 1

rm -rf $configFile

if [[ $removeTaint = true ]]; then
    kubectl taint nodes --all node-role.kubernetes.io/control-plane:NoSchedule-
else
    echo ""
    echo ""
    echo "If you want to schedule pods on the control plane node,"
    echo "remove the taint with the following command:"
    echo ""
    echo "kubectl taint nodes --all node-role.kubernetes.io/control-plane:NoSchedule-"
fi

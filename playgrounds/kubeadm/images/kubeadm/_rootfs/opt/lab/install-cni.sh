#!/usr/bin/env bash
set -euo pipefail

if [[ -z "${1:-}" ]]; then
    echo "Usage: $0 <network addon>"
    exit 1
fi

cni=$1

case $cni in
    "flannel")
        kubectl apply -f /usr/share/flannel/flannel.yaml
        ;;
    "canal")
        kubectl apply -f /usr/share/calico/canal.yaml
        ;;
    "cilium")
        cilium install --wait
        ;;
    "none")
        echo "Skipping CNI installation"
        ;;
    *)
        echo "Unsupported CNI: $cni"
        echo "Supported options: flannel, canal, cilium, none"
        ;;
esac

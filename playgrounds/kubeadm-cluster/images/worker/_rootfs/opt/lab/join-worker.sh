#!/usr/bin/env bash
set -euo pipefail

if [[ $(id -u) == 0 ]]; then
   echo "This script must NOT be run as root"
   exit 1
fi

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ -f $DIR/prepare.sh ]]; then
    $DIR/prepare.sh
fi

if [[ "$(systemctl --wait show -p Result --value image-loader.service)" != "success" ]]; then
    echo "WARNING: Image loading failed"
fi

if [[ -z ${KUBE_CPLANE_HOST:-} ]]; then
    KUBE_CPLANE_HOST="control-plane"
fi

token=$(sudo ssh -o StrictHostKeyChecking=no ${KUBE_CPLANE_HOST?} kubeadm token create)
caCertHash=$(sudo ssh -o StrictHostKeyChecking=no ${KUBE_CPLANE_HOST?} openssl x509 -pubkey -in /etc/kubernetes/pki/ca.crt | openssl rsa -pubin -outform der 2>/dev/null | openssl dgst -sha256 -hex | sed 's/^.* //')

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
EOF

sudo kubeadm join ${KUBE_CPLANE_HOST?}:6443 --config $configFile --ignore-preflight-errors NumCPU,Mem
sleep 1

rm -rf $configFile

#!/usr/bin/env bash
set -euo pipefail

if [[ -z ${KUBE_VERSION:-} ]]; then
    KUBE_VERSION=$(kubectl version --client -o json | jq -r '.clientVersion.gitVersion')
fi

mkdir -p /opt/images/kubeadm
for image in $(kubeadm config images list --kubernetes-version=${KUBE_VERSION?}); do
    crane -v pull $image /opt/images/kubeadm/$(echo ${image##*/} | cut -d: -f1 | awk -F/ '{print $NF}').tar
done

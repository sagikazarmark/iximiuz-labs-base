#!/usr/bin/env bash
set -euo pipefail

if [[ -z ${KUBE_VERSION:-} ]]; then
    KUBE_VERSION=$(curl -fsL https://dl.k8s.io/release/stable.txt)
fi

if [[ -z ${KUBE_MINOR_VERSION:-} ]]; then
    KUBE_MINOR_VERSION=${KUBE_VERSION%.*}
fi

KUBE_VERSION=${KUBE_VERSION#v}

curl -fsSL https://pkgs.k8s.io/core:/stable:/${KUBE_MINOR_VERSION?}/deb/Release.key | gpg --dearmor --yes -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/${KUBE_MINOR_VERSION?}/deb/ /" | tee /etc/apt/sources.list.d/kubernetes.list

apt-get update
apt-get install -y --no-install-recommends kubeadm=${KUBE_VERSION?}-* kubelet=${KUBE_VERSION?}-* kubectl=${KUBE_VERSION?}-*

kubeadm completion bash | tee /etc/bash_completion.d/kubeadm
kubectl completion bash | tee /etc/bash_completion.d/kubectl

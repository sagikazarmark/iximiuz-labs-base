#!/usr/bin/env bash
set -euo pipefail

tmp=$(mktemp -d) && cd $tmp
trap '[[ $? -eq 0 && ${DEBUG:-} != true ]] && rm -rf "$tmp"' EXIT

: "${KUBE_VERSION:=$(curl -fsL https://dl.k8s.io/release/stable.txt)}"

curl -fsSL --remote-name-all https://dl.k8s.io/${KUBE_VERSION}/bin/linux/amd64/kubectl{,.sha256}

echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check

install -m 755 kubectl /usr/local/bin

kubectl completion bash | tee /etc/bash_completion.d/kubectl

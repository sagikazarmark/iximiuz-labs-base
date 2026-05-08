#!/usr/bin/env bash
set -euo pipefail

tmp=$(mktemp -d) && cd $tmp
trap '[[ $? -eq 0 && ${DEBUG:-} != true ]] && rm -rf "$tmp"' EXIT

: "${KUBE_VERSION:=$(curl -fsL https://dl.k8s.io/release/stable.txt)}"
: "${KUBE_MINOR_VERSION:=${KUBE_VERSION%.*}}"
: "${CRICTL_VERSION=$(curl -s "https://api.github.com/repos/kubernetes-sigs/cri-tools/releases?per_page=100" | jq -r --arg prefix "${KUBE_MINOR_VERSION}." '.[] | select(.prerelease == false and .draft == false) | .tag_name | select(startswith($prefix))' | sort -V | tail -n1)}"

curl -fsSL --remote-name-all https://github.com/kubernetes-sigs/cri-tools/releases/download/${CRICTL_VERSION}/crictl-${CRICTL_VERSION}-linux-amd64.tar.gz{,.sha256}

echo "$(cat crictl-${CRICTL_VERSION}-linux-amd64.tar.gz.sha256)  crictl-${CRICTL_VERSION}-linux-amd64.tar.gz" | sha256sum --check

tar xzvofC crictl-${CRICTL_VERSION}-linux-amd64.tar.gz /usr/local/bin

crictl completion bash | tee /etc/bash_completion.d/crictl

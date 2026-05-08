#!/usr/bin/env bash
set -euo pipefail

tmp=$(mktemp -d) && cd $tmp
trap '[[ $? -eq 0 && ${DEBUG:-} != true ]] && rm -rf "$tmp"' EXIT

: "${HELM_VERSION:=$(curl -s https://api.github.com/repos/helm/helm/releases/latest | jq -r .tag_name)}"

curl -fsSL --remote-name-all https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz{,.sha256sum}

sha256sum --ignore-missing --check helm-${HELM_VERSION}-linux-amd64.tar.gz.sha256sum

tar xzvof helm-${HELM_VERSION}-linux-amd64.tar.gz

install -m 755 linux-amd64/helm /usr/local/bin

helm completion bash | tee /etc/bash_completion.d/helm

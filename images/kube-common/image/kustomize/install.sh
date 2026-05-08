#!/usr/bin/env bash
set -euo pipefail

tmp=$(mktemp -d) && cd $tmp
trap '[[ $? -eq 0 && ${DEBUG:-} != true ]] && rm -rf "$tmp"' EXIT

: "${KUSTOMIZE_VERSION:=$(curl -s 'https://api.github.com/repos/kubernetes-sigs/kustomize/releases?per_page=100' | jq -r '.[].tag_name | select(startswith("kustomize/")) | sub("^kustomize/";"")' | sort -Vr | head -n1)}"

curl -fsSLO https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize/${KUSTOMIZE_VERSION}/kustomize_${KUSTOMIZE_VERSION}_linux_amd64.tar.gz
curl -fsSLO https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize/${KUSTOMIZE_VERSION}/checksums.txt

sha256sum --ignore-missing --check checksums.txt

tar zxvof kustomize_${KUSTOMIZE_VERSION}_linux_amd64.tar.gz

install -m 755 kustomize /usr/local/bin/

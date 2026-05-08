#!/usr/bin/env bash
set -euo pipefail

tmp=$(mktemp -d) && cd $tmp
trap '[[ $? -eq 0 && ${DEBUG:-} != true ]] && rm -rf "$tmp"' EXIT

: "${KREW_VERSION:=$(curl -s https://api.github.com/repos/kubernetes-sigs/krew/releases/latest | jq -r .tag_name )}"

curl -fsSL --remote-name-all https://github.com/kubernetes-sigs/krew/releases/download/${KREW_VERSION}/krew-linux_amd64.tar.gz{,.sha256}

echo "$(cat krew-linux_amd64.tar.gz.sha256)  krew-linux_amd64.tar.gz" | sha256sum --check

tar zxvof krew-linux_amd64.tar.gz

install -m 755 krew-linux_amd64 /usr/local/bin/krew

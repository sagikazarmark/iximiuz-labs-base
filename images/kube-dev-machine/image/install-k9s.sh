#!/usr/bin/env bash
set -euo pipefail

tmp=$(mktemp -d) && cd $tmp
trap '[[ $? -eq 0 && ${DEBUG:-} != true ]] && rm -rf "$tmp"' EXIT

: "${K9S_VERSION:=$(curl -s https://api.github.com/repos/derailed/k9s/releases/latest | jq -r .tag_name)}"

curl -fsSLO https://github.com/derailed/k9s/releases/download/${K9S_VERSION}/k9s_linux_amd64.deb
curl -fsSLO https://github.com/derailed/k9s/releases/download/${K9S_VERSION}/checksums.sha256

sha256sum --ignore-missing --check checksums.sha256

dpkg -i k9s_linux_amd64.deb

k9s completion bash | tee /etc/bash_completion.d/k9s

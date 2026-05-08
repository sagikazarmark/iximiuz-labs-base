#!/usr/bin/env bash
set -euo pipefail

tmp=$(mktemp -d) && cd $tmp
trap '[[ $? -eq 0 && ${DEBUG:-} != true ]] && rm -rf "$tmp"' EXIT

: "${KUBELETCTL_VERSION:=$(curl -s https://api.github.com/repos/cyberark/kubeletctl/releases/latest | jq -r .tag_name)}"

curl -fsSLO https://github.com/cyberark/kubeletctl/releases/download/${KUBELETCTL_VERSION}/kubeletctl_linux_amd64

install -m 755 kubeletctl_linux_amd64 /usr/local/bin/kubeletctl

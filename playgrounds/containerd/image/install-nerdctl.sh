#!/usr/bin/env bash
set -euo pipefail

tmp=$(mktemp -d) && cd $tmp
trap '[[ $? -eq 0 && ${DEBUG:-} != true ]] && rm -rf "$tmp"' EXIT

: "${NERDCTL_VERSION:=$(curl -s https://api.github.com/repos/containerd/nerdctl/releases/latest | jq -r '.tag_name | sub("^v"; "")')}"

curl -fsSLO https://github.com/containerd/nerdctl/releases/download/v${NERDCTL_VERSION}/nerdctl-${NERDCTL_VERSION}-linux-amd64.tar.gz

curl -fsSLO https://github.com/containerd/nerdctl/releases/download/v${NERDCTL_VERSION}/SHA256SUMS

sha256sum --ignore-missing --check SHA256SUMS

tar xzvof nerdctl-${NERDCTL_VERSION}-linux-amd64.tar.gz

install -m 755 nerdctl /usr/local/bin

nerdctl completion bash | tee /etc/bash_completion.d/nerdctl

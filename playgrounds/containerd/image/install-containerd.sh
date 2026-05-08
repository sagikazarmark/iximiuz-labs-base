#!/usr/bin/env bash
set -euo pipefail

tmp=$(mktemp -d) && cd $tmp
trap '[[ $? -eq 0 && ${DEBUG:-} != true ]] && rm -rf "$tmp"' EXIT

: "${CONTAINERD_VERSION:=$(curl -s https://api.github.com/repos/containerd/containerd/releases/latest | jq -r '.tag_name | sub("^v"; "")')}"

curl -fsSL --remote-name-all https://github.com/containerd/containerd/releases/download/v${CONTAINERD_VERSION}/containerd-${CONTAINERD_VERSION}-linux-amd64.tar.gz{,.sha256sum}

sha256sum --check containerd-${CONTAINERD_VERSION}-linux-amd64.tar.gz.sha256sum

tar xzvofC containerd-${CONTAINERD_VERSION}-linux-amd64.tar.gz /usr/local

wget -P /etc/systemd/system https://raw.githubusercontent.com/containerd/containerd/main/containerd.service

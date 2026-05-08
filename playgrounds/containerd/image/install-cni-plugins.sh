#!/usr/bin/env bash
set -euo pipefail

tmp=$(mktemp -d) && cd $tmp
trap '[[ $? -eq 0 && ${DEBUG:-} != true ]] && rm -rf "$tmp"' EXIT

: "${CNI_PLUGINS_VERSION:=$(curl -s https://api.github.com/repos/containernetworking/plugins/releases/latest | jq -r .tag_name)}"

curl -fsSL --remote-name-all https://github.com/containernetworking/plugins/releases/download/${CNI_PLUGINS_VERSION}/cni-plugins-linux-amd64-${CNI_PLUGINS_VERSION}.tgz{,.sha256}

sha256sum --check cni-plugins-linux-amd64-${CNI_PLUGINS_VERSION}.tgz.sha256

install -d /opt/cni/bin

tar xzvofC cni-plugins-linux-amd64-${CNI_PLUGINS_VERSION}.tgz /opt/cni/bin

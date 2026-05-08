#!/usr/bin/env bash
set -euo pipefail

tmp=$(mktemp -d) && cd $tmp
trap '[[ $? -eq 0 && ${DEBUG:-} != true ]] && rm -rf "$tmp"' EXIT

: "${SONOBUOY_VERSION:=$(curl -s https://api.github.com/repos/vmware-tanzu/sonobuoy/releases/latest | jq -r '.tag_name | sub("^v"; "")')}"

curl -fsSL --remote-name-all https://github.com/vmware-tanzu/sonobuoy/releases/download/v${SONOBUOY_VERSION}/sonobuoy_${SONOBUOY_VERSION}_{linux_amd64.tar.gz,checksums.txt}

sha256sum --ignore-missing --check sonobuoy_${SONOBUOY_VERSION}_checksums.txt

tar xzvof sonobuoy_${SONOBUOY_VERSION}_linux_amd64.tar.gz

install -m 755 sonobuoy /usr/local/bin

sonobuoy completion bash | tee /etc/bash_completion.d/sonobuoy

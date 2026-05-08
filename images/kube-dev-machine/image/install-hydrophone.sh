#!/usr/bin/env bash
set -euo pipefail

tmp=$(mktemp -d) && cd $tmp
trap '[[ $? -eq 0 && ${DEBUG:-} != true ]] && rm -rf "$tmp"' EXIT

: "${HYDROPHONE_VERSION:=$(curl -s https://api.github.com/repos/kubernetes-sigs/hydrophone/releases/latest | jq -r '.tag_name | sub("^v"; "")')}"

curl -fsSL --remote-name-all https://github.com/kubernetes-sigs/hydrophone/releases/download/v${HYDROPHONE_VERSION}/hydrophone_{Linux_x86_64.tar.gz,${HYDROPHONE_VERSION}_checksums.txt}

sha256sum --ignore-missing --check hydrophone_${HYDROPHONE_VERSION}_checksums.txt

tar xzvof hydrophone_Linux_x86_64.tar.gz

install -m 755 hydrophone /usr/local/bin

# ERR Error: error loading kubeconfig: stat /root/.kube/config: no such file or directory.
# hydrophone completion bash | tee /etc/bash_completion.d/hydrophone

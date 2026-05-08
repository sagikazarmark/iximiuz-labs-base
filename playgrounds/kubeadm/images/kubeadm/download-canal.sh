#!/usr/bin/env bash
set -euo pipefail

tmp=$(mktemp -d) && cd $tmp
trap '[[ $? -eq 0 && ${DEBUG:-} != true ]] && rm -rf "$tmp"' EXIT

if [[ -z ${CALICO_VERSION:-} ]]; then
    CALICO_VERSION=$(curl -s https://api.github.com/repos/projectcalico/calico/releases/latest | jq -r .tag_name)
fi

curl -fsSLO "https://raw.githubusercontent.com/projectcalico/calico/${CALICO_VERSION}/manifests/canal.yaml"

mkdir -p /usr/share/calico
mv canal.yaml /usr/share/calico/

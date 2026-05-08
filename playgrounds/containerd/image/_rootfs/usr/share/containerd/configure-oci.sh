#!/usr/bin/env bash
set -euo pipefail

if [ $# -gt 0 ]; then
    runtime="$1"
else
    runtime="$(jq -r '."OCI runtime" // "runc"' /opt/iximiuz-labs/init-conditions.json)"
fi

sed -i "s|^default_runtime_name = .*|default_runtime_name = \"$runtime\"|" /etc/containerd/config.toml

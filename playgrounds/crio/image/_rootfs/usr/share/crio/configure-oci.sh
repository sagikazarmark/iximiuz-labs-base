#!/usr/bin/env bash
set -euo pipefail

if [ $# -gt 0 ]; then
    runtime="$1"
else
    runtime="$(jq -r '."OCI runtime" // "runc"' /opt/iximiuz-labs/init-conditions.json)"
fi

cat <<EOF | tee /etc/crio/crio.conf.d/99-oci-runtime.conf
[crio.runtime]
default_runtime = "$runtime"
EOF

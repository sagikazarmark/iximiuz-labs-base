#!/usr/bin/env bash
set -euo pipefail

if [[ -z "${1:-}" ]]; then
    echo "Usage: $0 <image.tar>"
    exit 1
fi

export PATH=$PATH:/opt/crio/bin

podman --runtime /usr/libexec/crio/crun load -i $1

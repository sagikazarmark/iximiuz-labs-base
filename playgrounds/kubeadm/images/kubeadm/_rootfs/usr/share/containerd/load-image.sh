#!/usr/bin/env bash
set -euo pipefail

if [[ -z "${1:-}" ]]; then
    echo "Usage: $0 <image.tar>"
    exit 1
fi

ctr -n k8s.io images import $1

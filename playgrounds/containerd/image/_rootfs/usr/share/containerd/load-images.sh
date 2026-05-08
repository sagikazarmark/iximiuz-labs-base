#!/usr/bin/env bash
set -euo pipefail

for img in "$@"; do
    /usr/share/containerd/load-image.sh $img
done

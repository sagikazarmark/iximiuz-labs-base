#!/usr/bin/env bash
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

for img in "$@"; do
    /usr/share/crio/load-image.sh $img
done

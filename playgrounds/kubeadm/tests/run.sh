#!/usr/bin/env bash
set -euo pipefail

if [ $# -eq 0 ]; then
    echo "Usage: $0 <playId>"
    echo "Error: playId argument is required"
    exit 1
fi

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

playId="$1"

labctl ssh --machine kubeadm $playId -- /opt/lab/init.sh --remove-taint
labctl ssh --machine dev-machine $playId -- /opt/lab/configure.sh

cat $DIR/tests.sh | labctl ssh --machine dev-machine $playId

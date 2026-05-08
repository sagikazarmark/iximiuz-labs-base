#!/usr/bin/env bash
set -euo pipefail

if [ $# -eq 0 ]; then
    echo "Usage: $0 <playId>"
    echo "Error: playId argument is required"
    exit 1
fi

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

playId="$1"

labctl ssh --machine kubeadm-01 $playId -- /opt/lab/init.sh
labctl ssh --machine kubeadm-02 $playId -- /opt/lab/join-controlplane.sh
labctl ssh --machine kubeadm-03 $playId -- /opt/lab/join-controlplane.sh
labctl ssh --machine kubeadm-04 $playId -- /opt/lab/join-worker.sh
labctl ssh --machine dev-machine $playId -- /opt/lab/configure.sh


cat $DIR/../../kubeadm/tests/tests.sh | labctl ssh --machine dev-machine $playId

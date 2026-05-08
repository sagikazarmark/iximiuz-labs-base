#!/usr/bin/env bash

curl -sk --max-time 1 https://control-plane:6443/healthz | grep -q 'ok'

if [[ $? -eq 0 ]]; then
    echo "Kubernetes control plane is already initialized."
    echo ""
    echo "Use /opt/playground/join-controlplane|worker.sh to join a node to the cluster."

    exit 1
fi

exit 0

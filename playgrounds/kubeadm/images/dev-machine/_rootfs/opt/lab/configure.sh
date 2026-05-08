#!/usr/bin/env bash
set -euo pipefail

if [[ -z ${KUBE_CPLANE_HOST:-} ]]; then
    KUBE_CPLANE_HOST="control-plane"
fi

# This should be done at this point, but let's make sure it's really done
mkdir -p $HOME/.kube

sudo scp -o StrictHostKeyChecking=no ${KUBE_CPLANE_HOST?}:/etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

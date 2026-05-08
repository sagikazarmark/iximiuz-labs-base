#!/usr/bin/env bash
set -euo pipefail

if [[ $(id -u) == 0 ]]; then
   echo "This script must NOT be run as root"
   exit 1
fi

sudo mkdir -p /root/.kube
sudo ln -s /etc/kubernetes/admin.conf /root/.kube/config

sudo chmod 666 /etc/kubernetes/admin.conf

mkdir -p $HOME/.kube
ln -s /etc/kubernetes/admin.conf $HOME/.kube/config

#!/usr/bin/env bash
set -euo pipefail

mkdir -p $HOME/.kube

cat <<EOF | tee -a $HOME/.bashrc $HOME/.bashrc

alias k=kubectl
complete -F __start_kubectl k
EOF

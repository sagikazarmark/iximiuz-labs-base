#!/usr/bin/env bash
set -euo pipefail

cat <<EOF | tee -a $HOME/.bashrc $HOME/.profile

alias crictl='sudo crictl'
EOF

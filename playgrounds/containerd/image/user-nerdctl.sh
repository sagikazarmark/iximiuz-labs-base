#!/usr/bin/env bash
set -euo pipefail

cat <<EOF | tee -a $HOME/.bashrc $HOME/.profile

alias nerdctl='sudo nerdctl'
EOF

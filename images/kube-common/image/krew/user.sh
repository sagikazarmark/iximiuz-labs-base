#!/usr/bin/env bash
set -euo pipefail

cat <<EOF | tee -a $HOME/.bashrc

export PATH="\$PATH:\${KREW_ROOT:-\$HOME/.krew}/bin"
EOF

krew install krew ctx ns tree tail neat view-secret

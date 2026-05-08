#!/usr/bin/env bash
set -euo pipefail

if [[ $(ps -p 1 -o comm=) == "systemd" ]]; then
    sudo systemctl enable --now crio image-loader
else
    sudo systemctl enable crio image-loader
fi

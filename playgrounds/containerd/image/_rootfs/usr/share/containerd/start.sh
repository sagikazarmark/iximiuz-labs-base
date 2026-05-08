#!/usr/bin/env bash
set -euo pipefail

if [[ $(ps -p 1 -o comm=) == "systemd" ]]; then
    sudo systemctl enable --now containerd image-loader
else
    sudo systemctl enable containerd image-loader
fi

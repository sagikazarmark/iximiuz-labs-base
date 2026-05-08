#!/usr/bin/env bash
set -uo pipefail

exitCode=0

if ! systemctl is-active crio; then
    echo "CRI-O service is not running"
    exitCode=1
fi

if ! sudo crictl images; then
    echo "crictl cannot talk to CRI-O"
    exitCode=1
fi

# TODO: add e2e tests downloading images, running containers, etc

exit $exitCode

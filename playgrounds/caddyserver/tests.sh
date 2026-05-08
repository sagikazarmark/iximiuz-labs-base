#!/usr/bin/env bash
set -uo pipefail

exitCode=0

if ! caddy version; then
    echo "Caddy execution failed"
    exitCode=1
fi

if ! systemctl is-active caddy; then
    echo "Caddy service is not active"
    exitCode=1
fi

if ! curl -I http://localhost; then
    echo "Caddy is not responding"
    exitCode=1
fi

exit $exitCode

#!/usr/bin/env bash
set -euo pipefail

tmp=$(mktemp -d) && cd $tmp
trap '[[ $? -eq 0 && ${DEBUG:-} != true ]] && rm -rf "$tmp"' EXIT

: "${RUNC_VERSION:=$(curl -s https://api.github.com/repos/opencontainers/runc/releases/latest | jq -r .tag_name)}"

curl -fsSL --remote-name-all https://github.com/opencontainers/runc/releases/download/${RUNC_VERSION}/runc.amd64{,.asc}

curl -fsSL https://raw.githubusercontent.com/opencontainers/runc/refs/heads/main/runc.keyring | gpg --no-default-keyring --keyring ./runc.kbx --import

gpg --no-default-keyring --keyring ./runc.kbx --verify runc.amd64.asc runc.amd64

install -m 755 runc.amd64 /usr/local/sbin/runc

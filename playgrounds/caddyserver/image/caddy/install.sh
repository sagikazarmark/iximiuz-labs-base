#!/usr/bin/env bash
set -euo pipefail

if [[ -z ${CADDY_VERSION:-} ]]; then
CADDY_VERSION=$(curl -s https://api.github.com/repos/caddyserver/caddy/releases/latest | jq -r '.tag_name | sub("^v"; "")')
fi

curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg

curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | tee /etc/apt/sources.list.d/caddy-stable.list

apt-get update

apt-get install -y --no-install-recommends caddy=${CADDY_VERSION}

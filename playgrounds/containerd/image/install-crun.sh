#!/usr/bin/env bash
set -euo pipefail

tmp=$(mktemp -d) && cd $tmp
trap '[[ $? -eq 0 && ${DEBUG:-} != true ]] && rm -rf "$tmp"' EXIT

: "${CRUN_VERSION:=$(curl -s https://api.github.com/repos/containers/crun/releases/latest | jq -r .tag_name)}"

curl -fsSL --remote-name-all https://github.com/containers/crun/releases/download/${CRUN_VERSION}/crun-${CRUN_VERSION}-linux-amd64{,.asc}

gpg --no-default-keyring --keyring ./crun.kbx --trust-model always --keyserver keyserver.ubuntu.com --recv-keys 67E38F7A8BA21772

gpg --no-default-keyring --keyring ./crun.kbx --verify crun-${CRUN_VERSION}-linux-amd64.asc crun-${CRUN_VERSION}-linux-amd64

install -m 755 crun-${CRUN_VERSION}-linux-amd64 /usr/local/sbin/crun

apt-get install -y --no-install-recommends libcap2 libseccomp2 libyajl2 libsystemd0 libselinux1 libapparmor1

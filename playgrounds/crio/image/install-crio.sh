#!/usr/bin/env bash
set -euo pipefail

: "${CRIO_VERSION:=$(curl -fsL https://dl.k8s.io/release/stable.txt | cut -d. -f1-2)}"

curl -fsSL https://download.opensuse.org/repositories/isv:/cri-o:/stable:/$CRIO_VERSION/deb/Release.key | gpg --dearmor -o /etc/apt/keyrings/cri-o-apt-keyring.gpg

echo "deb [signed-by=/etc/apt/keyrings/cri-o-apt-keyring.gpg] https://download.opensuse.org/repositories/isv:/cri-o:/stable:/$CRIO_VERSION/deb/ /" | tee /etc/apt/sources.list.d/cri-o.list

apt-get update
apt-get install -y cri-o

# podman dependencies
apt-get install -y --no-install-recommends libsubid4 libgpgme11t64

systemctl disable crio

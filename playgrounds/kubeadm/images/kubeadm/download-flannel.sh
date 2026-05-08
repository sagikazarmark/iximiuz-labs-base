#!/usr/bin/env bash
set -euo pipefail

tmp=$(mktemp -d) && cd $tmp
trap '[[ $? -eq 0 && ${DEBUG:-} != true ]] && rm -rf "$tmp"' EXIT

if [[ -z ${FLANNEL_VERSION:-} ]]; then
    FLANNEL_VERSION=$(curl -s https://api.github.com/repos/flannel-io/flannel/releases/latest | jq -r .tag_name)
fi

curl -fsSLO "https://github.com/flannel-io/flannel/releases/download/${FLANNEL_VERSION}/kube-flannel.yml"

mkdir -p /usr/share/flannel
mv kube-flannel.yml /usr/share/flannel/flannel.yaml

images=$(yq '
  ..
  | select(has("containers") or has("initContainers"))
  | (.containers[]?.image, .initContainers[]?.image)
' /usr/share/flannel/flannel.yaml | sort -u)

mkdir -p /opt/images/flannel
for image in $images; do
    crane pull $image /opt/images/flannel/$(echo ${image##*/} | cut -d: -f1 | awk -F/ '{print $NF}').tar
done

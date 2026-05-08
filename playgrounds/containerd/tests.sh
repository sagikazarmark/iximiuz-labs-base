#!/usr/bin/env bash
set -xuo pipefail

exitCode=0

if ! systemctl is-active containerd; then
    echo "containerd service is not running"
    exit 1
fi

if ! sudo nerdctl ps; then
    echo "nerdctl cannot talk to containerd"
    exit 1
fi

if ! sudo ctr images ls; then
    echo "ctr cannot talk to containerd"
    exit 1
fi

if ! sudo nerdctl pull --quiet ghcr.io/containerd/busybox:latest; then
    echo "nerdctl cannot pull images"
    exit 1
fi

if ! sudo ctr run ghcr.io/containerd/busybox:latest default dmesg < /dev/null; then
    echo "ctr cannot run containers with default runtime"
    exitCode=1
fi

if ! sudo ctr run --runtime io.containerd.runc.v2 --runc-binary /usr/local/sbin/runc ghcr.io/containerd/busybox:latest runc dmesg < /dev/null; then
    echo "ctr cannot run containers with runc runtime"
    exitCode=1
fi

if ! sudo ctr run --runtime io.containerd.runc.v2 --runc-binary /usr/local/sbin/crun ghcr.io/containerd/busybox:latest crun dmesg < /dev/null; then
    echo "ctr cannot run containers with crun runtime"
    exitCode=1
fi

# https://github.com/containerd/containerd/issues/6808
# if ! sudo ctr run -d --null-io --runtime io.containerd.runsc.v1 ghcr.io/containerd/busybox:latest runsc dmesg; then
#     echo "ctr cannot run containers with runsc runtime"
#     exitCode=1
# fi

exit $exitCode

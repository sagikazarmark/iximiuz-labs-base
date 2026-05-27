FROM root AS base

ARG DEBUG=false

USER root
ENV HOME=/root


ARG CRANE_VERSION
RUN set -xe; \
    ark get --path /usr/local/bin crane --version "${CRANE_VERSION}"; \
    chmod +x /usr/local/bin/crane

ARG KUBE_VERSION
RUN --mount=type=bind,source=install.sh,target=/install.sh /install.sh
RUN --mount=type=bind,source=download-kubeadm-images.sh,target=/download.sh /download.sh


FROM base AS flannel

ARG FLANNEL_VERSION
RUN --mount=type=bind,source=download-flannel.sh,target=/download.sh /download.sh


FROM flannel AS cni

ARG CALICO_VERSION
RUN --mount=type=bind,source=download-canal.sh,target=/download.sh /download.sh

ARG CILIUM_CLI_VERSION
RUN --mount=type=bind,source=install-cilium-cli.sh,target=/install.sh /install.sh


# TODO: figure out a way to avoid duplication
FROM flannel AS defaults

ARG KUBE_VERSION

COPY _rootfs/ /
RUN sed -i "s/KUBE_VERSION/${KUBE_VERSION?}/g" /opt/lab/kubeadm.yaml


ENV USER=laborant
USER $USER
ENV HOME=/home/$USER

COPY --chown=$USER:$USER welcome $HOME/.welcome


FROM cni

ARG KUBE_VERSION

COPY _rootfs/ /
RUN sed -i "s/KUBE_VERSION/${KUBE_VERSION?}/g" /opt/lab/kubeadm.yaml


ENV USER=laborant
USER $USER
ENV HOME=/home/$USER

COPY --chown=$USER:$USER welcome $HOME/.welcome

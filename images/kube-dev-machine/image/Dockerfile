FROM root

ARG DEBUG=false

USER root
ENV HOME=/root


ARG K9S_VERSION
RUN --mount=type=bind,source=install-k9s.sh,target=/install.sh /install.sh

ARG HELM_VERSION
RUN --mount=type=bind,source=install-helm.sh,target=/install.sh /install.sh

ARG SONOBUOY_VERSION
RUN --mount=type=bind,source=install-sonobuoy.sh,target=/install.sh /install.sh

ARG HYDROPHONE_VERSION
RUN --mount=type=bind,source=install-hydrophone.sh,target=/install.sh /install.sh

ARG KUBELETCTL_VERSION
RUN --mount=type=bind,source=install-kubeletctl.sh,target=/install.sh /install.sh


ENV USER=laborant
USER $USER
ENV HOME=/home/$USER

COPY --chown=$USER:$USER welcome $HOME/.welcome

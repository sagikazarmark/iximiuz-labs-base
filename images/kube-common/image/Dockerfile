FROM root

ARG DEBUG=false

USER root
ENV HOME=/root


ARG KUBE_VERSION
RUN --mount=type=bind,source=kubectl/install.sh,target=/install.sh /install.sh

ARG KREW_VERSION
RUN --mount=type=bind,source=krew/install.sh,target=/install.sh /install.sh

ARG KUSTOMIZE_VERSION
RUN --mount=type=bind,source=kustomize/install.sh,target=/install.sh /install.sh


RUN --mount=type=bind,source=kubectl/user.sh,target=/user.sh /user.sh
RUN --mount=type=bind,source=krew/user.sh,target=/user.sh /user.sh


ENV USER=laborant
USER $USER
ENV HOME=/home/$USER

RUN --mount=type=bind,source=kubectl/user.sh,target=/user.sh /user.sh
RUN --mount=type=bind,source=krew/user.sh,target=/user.sh /user.sh

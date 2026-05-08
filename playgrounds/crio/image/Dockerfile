FROM root AS podman

RUN set -xe; \
    sudo apt-get update; \
    sudo apt-get install -y --no-install-recommends podman conmon

FROM root AS base

USER root
ENV HOME=/root


ARG CRIO_VERSION
RUN --mount=type=bind,source=install-crio.sh,target=/install.sh /install.sh

ARG KUBE_VERSION
RUN --mount=type=bind,source=install-crictl.sh,target=/install.sh /install.sh


COPY _rootfs/ /
COPY --from=podman /usr/bin/podman /opt/crio/bin/podman
COPY --from=podman /usr/bin/conmon /opt/crio/bin/conmon


ENV USER=laborant
USER $USER
ENV HOME=/home/$USER

RUN --mount=type=bind,source=user-crictl.sh,target=/user.sh /user.sh


FROM base AS ready

RUN sudo /usr/share/crio/start.sh

ARG DEFAULT_OCI_RUNTIME=runc
RUN sudo /usr/share/crio/configure-oci.sh $DEFAULT_OCI_RUNTIME


FROM ready

COPY --chown=$USER:$USER welcome $HOME/.welcome
RUN sed -i "s/VERSION/$(crio --version | head -1 | cut -d ' ' -f3)/" $HOME/.welcome

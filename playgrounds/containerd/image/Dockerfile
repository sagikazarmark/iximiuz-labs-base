FROM root AS base

ARG DEBUG=false

USER root
ENV HOME=/root


ARG RUNC_VERSION
RUN --mount=type=bind,source=install-runc.sh,target=/install.sh /install.sh

ARG CRUN_VERSION
RUN --mount=type=bind,source=install-crun.sh,target=/install.sh /install.sh

# No version: installed from APT repository
RUN --mount=type=bind,source=install-runsc.sh,target=/install.sh /install.sh

ARG CONTAINERD_VERSION
RUN --mount=type=bind,source=install-containerd.sh,target=/install.sh /install.sh

ARG CNI_PLUGINS_VERSION
RUN --mount=type=bind,source=install-cni-plugins.sh,target=/install.sh /install.sh

ARG NERDCTL_VERSION
RUN --mount=type=bind,source=install-nerdctl.sh,target=/install.sh /install.sh


COPY _rootfs/ /


ENV USER=laborant
USER $USER
ENV HOME=/home/$USER

RUN --mount=type=bind,source=user-containerd.sh,target=/user.sh /user.sh
RUN --mount=type=bind,source=user-nerdctl.sh,target=/user.sh /user.sh


FROM base AS ready

RUN sudo /usr/share/containerd/start.sh

ARG DEFAULT_OCI_RUNTIME=runc
RUN sudo /usr/share/containerd/configure-oci.sh $DEFAULT_OCI_RUNTIME


FROM ready

COPY --chown=$USER:$USER welcome $HOME/.welcome
RUN sed -i "s/VERSION/$(containerd --version | cut -d ' ' -f3)/" $HOME/.welcome

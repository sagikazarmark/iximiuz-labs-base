FROM root

ARG DEBUG=false

USER root
ENV HOME=/root


COPY _rootfs/ /


ENV USER=laborant
USER $USER
ENV HOME=/home/$USER

FROM root AS base

USER root
ENV HOME=/root


RUN --mount=type=bind,source=caddy/install.sh,target=/install.sh /install.sh

COPY caddy/caddy-trust.service /etc/systemd/system/
RUN systemctl enable caddy-trust.service


ENV USER=laborant
USER $USER
ENV HOME=/home/$USER


FROM base

COPY --chown=$USER:$USER welcome $HOME/.welcome
RUN sed -i "s/VERSION/$(caddy version | cut -d ' ' -f1)/" $HOME/.welcome

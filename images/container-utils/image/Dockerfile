FROM root

ARG DIVE_VERSION
RUN set -xe; \
    sudo ark get --path /usr/local/bin dive --version "${DIVE_VERSION}"; \
    sudo chmod +x /usr/local/bin/dive

ARG CRANE_VERSION
RUN set -xe; \
    sudo ark get --path /usr/local/bin crane --version "${CRANE_VERSION}"; \
    sudo chmod +x /usr/local/bin/crane

ARG REGCTL_VERSION
RUN set -xe; \
    sudo ark get --path /usr/local/bin regctl --version "${REGCTL_VERSION}"; \
    sudo chmod +x /usr/local/bin/regctl

RUN sudo apt-get update && sudo apt-get -y --no-install-recommends install skopeo

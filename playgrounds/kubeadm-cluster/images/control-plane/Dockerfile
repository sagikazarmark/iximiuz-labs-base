FROM root

RUN sudo apt-get install -y --no-install-recommends keepalived

COPY _rootfs/ /

ARG KUBE_VERSION
RUN sudo sed -i "s/KUBE_VERSION/${KUBE_VERSION?}/g" /opt/lab/kubeadm.yaml

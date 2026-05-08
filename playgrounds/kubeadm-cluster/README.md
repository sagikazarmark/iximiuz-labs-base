::image-box
---
:src: __static__/arch-v2.svg
:alt: 'kubeadm cluster architecture'
---
::

## 🔧 System Components

- `kubelet`: The primary node agent that runs on each node
- **Container Runtimes:**
  - containerd: Lightweight container runtime (recommended)
  - CRI-O: Lightweight container runtime for Kubernetes
- **Networking:**
  - CNI plugins: Container Network Interface plugins
  - Flannel: Network overlay for pod-to-pod communication

## 🛠️ Tools

- `kubeadm`: Cluster lifecycle management and bootstrapping
- `kubectl` (alias: `k`): Kubernetes cluster management and debugging
- `nerdctl`: Docker-compatible CLI for `containerd`
- `krew`: `kubectl` plugin manager for extending functionality

## 🎯 Getting Started

### Quick Setup


## 📚 Learn More

- Kubernetes
  - [Installing kubeadm](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm)
  - [Creating a cluster with kubeadm](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm)
  - [Container Runtimes](https://kubernetes.io/docs/setup/production-environment/container-runtimes)
- Container runtimes
  - [Containerd installation](https://github.com/containerd/containerd/blob/main/docs/getting-started.md)
  - [CRI-O installation](https://github.com/cri-o/packaging/blob/main/README.md#usage)
- Networking
  - [Network addons](https://kubernetes.io/docs/concepts/cluster-administration/addons/#networking-and-network-policy)
  - [Flannel](https://github.com/flannel-io/flannel)

## 🧩 Related Content

### 🧪 Playgrounds

- [Kubernetes Playgrounds](https://labs.iximiuz.com/playgrounds?category=kubernetes) _(official)_
- [contaiNERD CTL](https://labs.iximiuz.com/playgrounds/nerdctl) _(official)_
- [containerd](https://labs.iximiuz.com/playgrounds/containerd-3bd0327f)
- [CRI-O](https://labs.iximiuz.com/playgrounds/cri-o-runtime-2f805996)

**Happy learning! 🚀**

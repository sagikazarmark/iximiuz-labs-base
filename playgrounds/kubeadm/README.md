::remark-box
This is a **single-machine** playground. A multi-machine playground for larger and HA clusters is WIP.
::

## 🔧 System Components

- `kubelet`: The primary node agent that runs on each node
- **Container Runtimes:**
  - containerd: Lightweight container runtime (recommended)
  - CRI-O: Lightweight container runtime for Kubernetes
- **Networking:**
  - CNI plugins: Container Network Interface plugins
  - Flannel: Network overlay for pod-to-pod communication
  - Canal: Calico for network policy and Flannel

## 🛠️ Tools

- `kubeadm`: Cluster lifecycle management and bootstrapping
- `kubectl` (alias: `k`): Kubernetes cluster management and debugging
- `nerdctl`: Docker-compatible CLI for `containerd`
- `krew`: `kubectl` plugin manager for extending functionality

## 🎯 Getting Started

### Quick Setup

If you want to quickly set up a working cluster, use the automated script:

```bash
/opt/lab/init.sh --remove-taint
```

::details-box
---
:summary: Available options
---

| **Option**         | **Default** | **Description**                                                                        |
|--------------------|-------------|----------------------------------------------------------------------------------------|
| `--remove-taint`   |   `false`   | Remove the `NoSchedule` taint that may prevent pods from being scheduled to this node. |
| `--cni`            |  `flannel`  | Network add-on to install. Valid values: `none`, `flannel`, `canal`                    |
| `--no-load-images` |   `false`   | Do not load the images from local cache.                                               |

::remark-box
---
kind: warning
---

⚠️ When `none` is selected as the network addon, the initialization script will skip installing any CNI plugin.
::
::

On the `dev-machine`, run the following command to configure `kubectl`:

```bash
/opt/lab/configure.sh
```

### Manual Setup

For a manual setup, check out [this tutorial](https://labs.iximiuz.com/tutorials/provision-k8s-kubeadm-900d1e53).

### Verify Your Cluster

```bash
# Check all system pods are running
kubectl get pods --all-namespaces

# Deploy a test application
kubectl create deployment podinfo --image=ghcr.io/stefanprodan/podinfo --port=9898
kubectl expose deployment podinfo --port=9898

# Wait for the pod to be ready
kubectl wait --for=condition=Ready pods --all --timeout=300s

# Check the deployment
kubectl get pods,services

# Send a request to the application
curl http://$(kubectl get svc podinfo -o jsonpath='{.spec.clusterIP}:{.spec.ports[0].port}')
```

### Resetting the Cluster

The easiest way to reset the cluster is terminating the playground and starting a new one.

That being said, it's a good idea to learn how to reset the cluster manually.

First, reset the cluster itself using `kubeadm`:

```bash
kubeadm reset -f
```

Stop `kubelet`:

```bash
systemctl stop kubelet
```

Then cleanup any CNI config created by the network addon you installed:

```bash
rm -rf /etc/cni/net.d/*.{conf,conflist}
```

Delete any CNI interfaces created by the network addon:

```bash
ip link delete cni0

# For flannel
ip link delete flannel.1
```

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

### 📖 Tutorials

- [Provisioning a Kubernetes Cluster with kubeadm](https://labs.iximiuz.com/tutorials/provision-k8s-kubeadm-900d1e53)

### 🧪 Playgrounds

- [Kubernetes Playgrounds](https://labs.iximiuz.com/playgrounds?category=kubernetes) _(official)_
- [contaiNERD CTL](https://labs.iximiuz.com/playgrounds/nerdctl) _(official)_
- [containerd](https://labs.iximiuz.com/playgrounds/containerd-3bd0327f)
- [CRI-O](https://labs.iximiuz.com/playgrounds/cri-o-runtime-2f805996)

**Happy learning! 🚀**

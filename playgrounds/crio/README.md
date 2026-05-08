This environment is set up for learning how to work with **[CRI-O](https://cri-o.io/)** — a lightweight container runtime specifically designed for Kubernetes, implementing the Container Runtime Interface (CRI).

## 🔧 System Components

- `cri-o`: The core CRI-compatible container runtime daemon.
- `runc`/`crun`: Low-level OCI runtime implementations.
- `conmon`: Container monitoring tool that handles container lifecycle.

## 🛠️ Tools

- `crictl`: The primary CLI for interacting with CRI-O and other CRI-compatible runtimes.

## 🎯 Getting Started

### Pull and list images

```bash
crictl pull hello-world:latest

crictl images
```

### Run containers

```bash
# Create a pod first (CRI-O works with pods)
crictl runp pod-config.yaml

# Run container in the pod
crictl create <pod-id> container-config.yaml pod-config.yaml
crictl start <container-id>
```

### Manage pods

```bash
# List pods
crictl pods

# Create a pod
crictl runp pod-config.yaml

# Stop and remove a pod
crictl stopp <pod-id>
crictl rmp <pod-id>
```

## 🏷️ Versions

- **CRI-O:** @crioVersion@

## 📚 Learn More

- CRI-O docs: [https://cri-o.io/](https://cri-o.io/)
- crictl reference: [https://kubernetes.io/docs/tasks/debug/debug-cluster/crictl/](https://kubernetes.io/docs/tasks/debug/debug-cluster/crictl/)
- CRI specification: [https://github.com/kubernetes/cri-api](https://github.com/kubernetes/cri-api)
- crictl help: `crictl --help`

## 🧩 Related Content

### 🧪 Playgrounds

- [contaiNERD CTL](https://labs.iximiuz.com/playgrounds/nerdctl) _(official)_

**Happy learning! 🚀**

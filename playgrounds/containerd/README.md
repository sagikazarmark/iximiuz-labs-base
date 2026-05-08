## 🔧 System Components

- `containerd`: The core container runtime daemon.
- `runc`/`crun`/`runsc`: Low-level OCI runtime implementations.

## 🛠️ Tools

- `ctr`: A low-level CLI for interacting with containerd directly.
- `nerdctl`: A Docker-compatible CLI for containerd, easier for day-to-day use.

## 🎯 Getting Started

### Pull and list images

::tabbed
---
tabs:
  - name: nerdctl
    title: nerdctl
  - name: ctr
    title: ctr
---
#nerdctl
```bash
nerdctl pull hello-world:latest

nerdctl images
```

#ctr
```bash
ctr images pull docker.io/library/hello-world:latest

ctr images ls
```
::

### Run containers

::tabbed
---
tabs:
  - name: nerdctl
    title: nerdctl
  - name: ctr
    title: ctr
---
#nerdctl
```bash
nerdctl run --rm hello-world:latest
```

#ctr
```bash
ctr run --rm docker.io/library/hello-world:latest hello
```
::

### Running a container with a selected OCI runtime

::tabbed
---
tabs:
  - name: nerdctl
    title: nerdctl
  - name: ctr
    title: ctr
---
#nerdctl
```bash
nerdctl run -t --runtime runc docker.io/library/hello-world:latest
nerdctl run -t --runtime crun docker.io/library/hello-world:latest

nerdctl run -t --runtime runsc ghcr.io/containerd/busybox:latest dmesg
```

#ctr
```bash
ctr image pull docker.io/library/hello-world:latest
ctr image pull ghcr.io/containerd/busybox:latest

ctr run --rm -t --runtime io.containerd.runc.v2 --runc-binary /usr/local/sbin/runc docker.io/library/hello-world:latest runc
ctr run --rm -t --runtime io.containerd.runc.v2 --runc-binary /usr/local/sbin/crun docker.io/library/hello-world:latest crun

ctr run --rm -t --runtime io.containerd.runsc.v1 ghcr.io/containerd/busybox:latest runsc dmesg
```
::

## 🤔 Choosing the Right Tool

| Use Case                           | Recommended Tool | Why                                 |
|------------------------------------|------------------|-------------------------------------|
| Learning the basics                | `nerdctl`        | Familiar commands, less complexity  |
| Understanding containerd internals | `ctr`            | Direct API access, explicit control |
| Production automation              | `ctr`            | Minimal overhead, precise control   |
| Development workflows              | `nerdctl`        | Build, compose, volume support      |

## 🏷️ Versions

- OCI runtime
  - **runc:** @runcVersion@
  - **crun:** @crunVersion@
  - **runsc:** latest from the gVisor apt repository
- **containerd:** @containerdVersion@
- **CNI plugins:** @cniPluginsVersion@
- **nerdctl:** @nerdctlVersion@

## 📚 Learn More

- [containerd documentation](https://github.com/containerd/containerd/tree/main/docs)
- [nerdctl documentation](https://github.com/containerd/nerdctl)

## 🧩 Related Content

### 🧪 Playgrounds

- [contaiNERD CTL](https://labs.iximiuz.com/playgrounds/nerdctl) _(official)_
- [CRI-O](https://labs.iximiuz.com/playgrounds/cri-o-runtime-2f805996)

### 📚 Courses

- [How (and Why) to Use containerd from the Command Line](https://labs.iximiuz.com/courses/containerd-cli) _(official)_

### 🏆 Challenges

- [Install and Configure containerd on a Linux Host](https://labs.iximiuz.com/challenges/install-and-configure-containerd) _(official)_
- [Start and Inspect a Container With containerd CLI - ctr](https://labs.iximiuz.com/challenges/start-container-with-ctr) _(official)_
- [Start and Inspect a Container With contaiNERD CTL (nerdctl)](https://labs.iximiuz.com/challenges/start-container-with-nerdctl) _(official)_
- [Network Access to a Container Started by ctr](https://labs.iximiuz.com/challenges/access-containerd-container-with-no-published-ports) _(official)_
- [Working With containerd Namespaces](https://labs.iximiuz.com/challenges/containerd-namespaces) _(official)_

**Happy learning! 🚀**

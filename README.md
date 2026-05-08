# iximiuz-labs-base

Base playgrounds and reusable image build modules for
[iximiuz Labs](https://labs.iximiuz.com) content.

This repository is a Nix flake that wires
[`niximiuz`](https://github.com/sagikazarmark/niximiuz) and
[`nix-docker-bake`](https://github.com/sagikazarmark/nix-docker-bake)
together. It produces iximiuz Labs playground content derivations and Docker
Buildx bake files for the images those playgrounds use.

## Repository layout

- `flake.nix` defines the flake outputs, package/check derivations, registry,
  default root filesystem, and development shell.
- `vars.nix` holds shared version defaults used by image and playground modules.
- `images/` contains reusable bake modules for common base images.
- `playgrounds/` contains playground manifests, markdown, covers, image modules,
  and tests.
- `justfile` provides the common local build, test, push, and inspection
  commands.

Current reusable image modules:

- `container-utils`
- `cri`
- `kube-common`
- `kube-dev-machine`

Current playgrounds:

- `caddyserver`
- `containerd`
- `crio`
- `kubeadm`
- `kubeadm-cluster`

## Development

Enter the development shell:

```sh
nix develop
```

List available outputs and modules:

```sh
just list
just list-playgrounds
just list-bake
```

Build playground content or a bake file:

```sh
just build containerd dev
just build-bake kube-common dev
```

Build a playground image locally:

```sh
just build-playground containerd dev
```

Run a playground test against a temporary iximiuz Labs session:

```sh
just test containerd dev
```

## Flake outputs

- `packages.<system>.playground-<name>-<channel>` builds playground content.
- `packages.<system>.bake-<name>-<channel>` builds Docker Buildx bake files.
- `checks.<system>` mirrors the package set for `nix flake check`.
- `lib.bakeModules` exposes the discovered image and playground bake modules.

CI runs `nix flake check` on pull requests and pushes to `main`.

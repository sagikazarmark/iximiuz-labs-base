set shell := ["bash", "-euo", "pipefail", "-c"]

export BUILDX_BAKE_ENTITLEMENTS_FS := "0"

[private]
default:
    @just --list

# List every flake output.
list:
    @nix flake show --allow-import-from-derivation

# List playground entries.
list-playgrounds:
    @for d in playgrounds/*; do test -f "$d/manifest.nix" && basename "$d"; done

# List bake modules.
list-bake:
    @for d in images/* playgrounds/*; do test -f "$d/bake.nix" && basename "$d"; done | sort

# Build a playground content derivation and print its store path.
build name channel="dev":
    @nix build --print-out-paths --no-link ".#playground-{{ name }}-{{ channel }}"

# Build the bake-file derivation for an image module and print its store path.
build-bake name channel="dev":
    @nix build --print-out-paths --no-link ".#bake-{{ name }}-{{ channel }}"

# Build an image module locally via docker buildx bake.
build-image name channel="dev":
    #!/usr/bin/env bash
    bake=$(just build-bake {{ name }} {{ channel }})
    docker buildx bake --progress plain -f "$bake"

# Build playground Nix outputs, then build its image locally.
build-playground name channel="dev":
    #!/usr/bin/env bash
    content=$(just build {{ name }} {{ channel }})
    bake=$(just build-bake {{ name }} {{ channel }})
    printf 'content: %s\n' "$content"
    printf 'bake: %s\n' "$bake"
    docker buildx bake -f "$bake"

# Push an image module via docker buildx bake.
push-image name channel="dev":
    #!/usr/bin/env bash
    bake=$(just build-bake {{ name }} {{ channel }})
    docker buildx bake -f "$bake" --push

# Push a playground manifest to the platform via labctl.
push-content name channel="dev":
    #!/usr/bin/env bash
    out=$(just build {{ name }} {{ channel }})
    slug=$(yq -r .name "$out/content/manifest.yaml")
    labctl playground update --dir "$out/content" --force "$slug"

# Push a playground image and manifest.
push name channel="dev":
    just push-image {{ name }} {{ channel }}
    just push-content {{ name }} {{ channel }}

# Open a live playground session.
start name channel="dev":
    #!/usr/bin/env bash
    out=$(just build {{ name }} {{ channel }})
    slug=$(yq -r .name "$out/content/manifest.yaml")
    labctl playground start --open "$slug"

# Run playground tests against a temporary live platform session.
test name channel="dev" tier="premium":
    #!/usr/bin/env bash
    out=$(just build {{ name }} {{ channel }})
    slug=$(yq -r .name "$out/content/manifest.yaml")

    startArgs=(-q)
    if [[ "{{ tier }}" == "free" ]]; then
      startArgs+=(--as-free-tier-user)
    fi

    playId=$(labctl playground start "${startArgs[@]}" "$slug")
    trap '[[ ${DEBUG:-} != true ]] && labctl playground destroy "$playId"' EXIT

    if [[ -f "playgrounds/{{ name }}/tests/run.sh" ]]; then
      bash "playgrounds/{{ name }}/tests/run.sh" "$playId"
    elif [[ -f "playgrounds/{{ name }}/tests.sh" ]]; then
      labctl ssh --user laborant "$playId" < "playgrounds/{{ name }}/tests.sh"
    else
      echo "no tests found for playground: {{ name }}" >&2
      exit 1
    fi

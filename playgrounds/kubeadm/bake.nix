{
  lib,
  cri,
  containerd,
  crio,
  kube-dev-machine,
  kubeVersion,
  flannelVersion,
  ...
}:
let
  args = lib.toBuildArgs { inherit kubeVersion flannelVersion; } // {
    # Until the following PR is released: https://github.com/google/go-containerregistry/issues/2309
    CRANE_VERSION = "v0.21.5";
  };

  base = lib.mkTarget {
    inherit args;

    name = "base";
    platforms = [ "linux/amd64" ];
    context = lib.mkContext ./images/kubeadm;
  };

  main = lib.tagTarget "playgrounds/kubeadm" (
    base
    // {
      name = "main";
      contexts = {
        root = cri.targets.default;
      };
    }
  );

  withContainerd = base // {
    name = "containerd";
    contexts = {
      root = containerd.targets.ready;
    };
  };

  withCrio = base // {
    name = "crio";
    contexts = {
      root = crio.targets.ready;
    };
  };

  defaults = lib.tagTarget "playgrounds/kubeadm/defaults" (
    withContainerd
    // {
      name = "defaults";
      target = "defaults";
    }
  );

  devMachine = lib.tagTarget "playgrounds/kubeadm/dev-machine" (
    lib.mkTarget {
      name = "dev-machine";
      platforms = [ "linux/amd64" ];
      context = lib.mkContext ./images/dev-machine;
      contexts = {
        root = kube-dev-machine.targets.default;
      };
    }
  );
in
{
  targets = {
    inherit main base defaults;
    "dev-machine" = devMachine;
    containerd = withContainerd;
    crio = withCrio;
  };
  groups = {
    default = [
      main
      defaults
      devMachine
    ];
  };
}

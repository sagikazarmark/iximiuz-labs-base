{
  lib,
  container-utils,
  containerd,
  crio,
  ...
}:
let
  containerdBase = containerd.targets.base // {
    name = "containerd";
    contexts = {
      root = container-utils.targets.default;
    };
  };

  crioBase = crio.targets.base // {
    name = "crio";
    contexts = {
      root = containerdBase;
    };
  };
in
{
  targets = {
    default = lib.mkTarget {
      name = "default";
      platforms = [ "linux/amd64" ];
      context = lib.mkContext ./image;
      contexts = {
        root = crioBase;
      };
    };

    containerd = containerdBase;
    crio = crioBase;
  };
}

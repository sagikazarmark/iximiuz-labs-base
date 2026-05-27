let
  defaults = import ./vars.nix;
in
{
  lib,
  defaultRoot,
  container-utils,
  runcVersion ? defaults.runcVersion,
  crunVersion ? defaults.crunVersion,
  containerdVersion ? defaults.containerdVersion,
  cniPluginsVersion ? defaults.cniPluginsVersion,
  nerdctlVersion ? defaults.nerdctlVersion,
  ...
}:
let
  args = lib.toBuildArgs {
    inherit
      runcVersion
      crunVersion
      containerdVersion
      cniPluginsVersion
      nerdctlVersion
      ;
  };

  base = lib.mkTarget {
    inherit args;

    name = "base";
    target = "base";
    platforms = [ "linux/amd64" ];
    context = lib.mkContext ./image;
    contexts = {
      root = defaultRoot;
    };
  };

  ready = base // {
    name = "ready";
    target = "ready";
  };

  main = lib.tagTarget "base/containerd" (
    base
    // {
      name = "main";
      target = null;
      contexts = {
        root = container-utils.targets.default;
      };
    }
  );
in
{
  targets = { inherit base ready main; };
  groups = {
    default = [ main ];
  };
}

let
  defaults = import ./vars.nix;
in
{
  lib,
  defaultRoot,
  container-utils,
  kubeVersion,
  crioVersion ? defaults.crioVersion,
  ...
}:
let
  args = lib.toBuildArgs { inherit crioVersion kubeVersion; };

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

  main = lib.tagTarget "playgrounds/cri-o" (
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

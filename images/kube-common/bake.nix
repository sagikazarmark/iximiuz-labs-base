let
  defaults = import ./vars.nix;
in
{
  lib,
  defaultRoot,
  container-utils,
  kubeVersion,
  krewVersion ? defaults.krewVersion,
  kustomizeVersion ? defaults.kustomizeVersion,
  ...
}:
let
  args = lib.toBuildArgs {
    inherit
      kubeVersion
      krewVersion
      kustomizeVersion
      ;
  };

  base = {
    inherit args;

    platforms = [ "linux/amd64" ];
    context = lib.mkContext ./image;
    contexts = {
      root = defaultRoot;
    };
  };
in
{
  targets = {

    default = lib.mkTarget base // {
      name = "default";
    };

    "with-container-utils" = lib.mkTarget base // {
      name = "with-container-utils";
      contexts = {
        root = container-utils.targets.default;
      };
    };
  };
}

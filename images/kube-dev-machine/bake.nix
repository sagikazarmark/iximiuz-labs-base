let
  defaults = import ./vars.nix;
in
{
  lib,
  kube-common,
  k9sVersion ? defaults.k9sVersion,
  helmVersion ? defaults.helmVersion,
  ...
}:
let
  args = lib.toBuildArgs {
    inherit
      k9sVersion
      helmVersion
      ;
  };
in
{
  targets = {
    default = lib.mkTarget {
      inherit args;

      name = "default";
      platforms = [ "linux/amd64" ];
      context = lib.mkContext ./image;
      contexts = {
        root = kube-common.targets."with-container-utils";
      };
    };
  };
}

{
  lib,
  defaultRoot,
  ...
}:
let
  base = lib.mkTarget {
    name = "base";
    target = "base";
    platforms = [ "linux/amd64" ];
    context = lib.mkContext ./image;
    contexts = {
      root = defaultRoot;
    };
  };
in
{
  targets = {
    inherit base;

    default = lib.tagTarget "base/caddyserver" (
      base
      // {
        name = "default";
        target = null;
      }
    );
  };
}

{
  lib,
  defaultRoot,
  ...
}:
{
  targets = {
    default = lib.mkTarget {
      name = "default";
      platforms = [ "linux/amd64" ];
      context = lib.mkContext ./image;
      contexts = {
        root = defaultRoot;
      };
    };
  };
}

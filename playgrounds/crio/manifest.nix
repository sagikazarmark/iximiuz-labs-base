let
  defaults = import ./vars.nix;
in
{
  images,
  lib,
  crioVersion ? defaults.crioVersion,
  ...
}:
{
  base = "flexbox";
  title = "CRI-O";
  description = "Lightweight Container Runtime for Kubernetes";
  channels = {
    live = {
      name = "cri-o-runtime-2f805996";
      public = true;
    };
    dev = {
      name = "cri-o-runtime-2f805996.dev";
    };
  };
  cover = lib.hashedCover ./cover.png;
  markdown = builtins.replaceStrings [ "@crioVersion@" ] [ crioVersion ] (
    builtins.readFile ./README.md
  );
  categories = [
    "linux"
    "containers"
  ];
  playground = {
    networks = [
      {
        name = "local";
        subnet = "172.16.0.0/24";
      }
    ];
    machines = [
      {
        name = "cri-o";
        users = [
          { name = "root"; }
          {
            name = "laborant";
            default = true;
          }
        ];
        drives = [
          {
            source = images.main.passthru.imageRef;
            mount = "/";
          }
        ];
        network.interfaces = [
          { network = "local"; }
        ];
        resources = {
          cpuCount = 4;
          ramSize = "8GiB";
        };
      }
    ];
    tabs = [
      {
        id = "terminal";
        kind = "terminal";
        name = "cri-o";
        machine = "cri-o";
      }
    ];
  };
}

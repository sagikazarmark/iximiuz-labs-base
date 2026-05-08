let
  defaults = import ./vars.nix;
in
{
  images,
  lib,
  runcVersion ? defaults.runcVersion,
  crunVersion ? defaults.crunVersion,
  containerdVersion ? defaults.containerdVersion,
  cniPluginsVersion ? defaults.cniPluginsVersion,
  nerdctlVersion ? defaults.nerdctlVersion,
  ...
}:
let
  markdown =
    builtins.replaceStrings
      [
        "@runcVersion@"
        "@crunVersion@"
        "@containerdVersion@"
        "@cniPluginsVersion@"
        "@nerdctlVersion@"
      ]
      [
        runcVersion
        crunVersion
        containerdVersion
        cniPluginsVersion
        nerdctlVersion
      ]
      (builtins.readFile ./README.md);
in
{
  base = "flexbox";
  title = "containerd";
  description = "An industry-standard container runtime with an emphasis on simplicity, robustness and portability.";
  channels = {
    live = {
      name = "containerd-3bd0327f";
      public = true;
    };
    dev = {
      name = "containerd-3bd0327f.dev";
    };
  };
  cover = lib.hashedCover ./cover.png;
  inherit markdown;
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
        name = "containerd";
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
        name = "containerd";
        machine = "containerd";
      }
    ];
  };
}

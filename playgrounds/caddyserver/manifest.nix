{
  images,
  lib,
  ...
}:
{
  base = "flexbox";
  title = "Caddy";
  description = "A powerful, extensible platform to serve your sites, services, and apps.";
  channels = {
    live = {
      name = "caddyserver-18c3762d";
      public = true;
    };
    dev = {
      name = "caddyserver-18c3762d.dev";
    };
  };
  cover = lib.hashedCover ./cover.png;
  categories = [
    "linux"
    "networking"
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
        name = "caddy";
        users = [
          { name = "root"; }
          {
            name = "laborant";
            default = true;
          }
        ];
        drives = [
          {
            source = images.default.passthru.imageRef;
            mount = "/";
          }
        ];
        network.interfaces = [
          { network = "local"; }
        ];
        resources = {
          cpuCount = 2;
          ramSize = "2GiB";
        };
      }
    ];
    tabs = [
      {
        id = "terminal-caddy";
        kind = "terminal";
        name = "caddy";
        machine = "caddy";
      }
      {
        kind = "http-port";
        name = "Web";
        number = 80;
        machine = "caddy";
      }
    ];
  };
}

{
  description = "Base playgrounds and reusable bake modules for iximiuz labs content";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    bake.url = "github:sagikazarmark/nix-docker-bake/v0.10.0";
    bake.inputs.nixpkgs.follows = "nixpkgs";

    niximiuz.url = "github:sagikazarmark/niximiuz";
    niximiuz.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      bake,
      niximiuz,
    }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forAllSystems =
        f:
        nixpkgs.lib.genAttrs systems (
          system:
          f {
            inherit system;
            pkgs = import nixpkgs {
              inherit system;
              overlays = [ niximiuz.overlays.default ];
            };
          }
        );

      loaders = niximiuz.lib.loaders;

      imageBakeModules = loaders.bake.discoverBakeModules ./images;
      playgroundBakeModules = loaders.bake.discoverBakeModules ./playgrounds;
      bakeModules = imageBakeModules // playgroundBakeModules;

      registry = "ghcr.io/sagikazarmark/iximiuz-labs";
      defaultRoot = "docker-image://ghcr.io/iximiuz/labs/rootfs:ubuntu-24-04";
      vars = import ./vars.nix;

      packagesFor =
        pkgs:
        let
          content = niximiuz.mkContentPipeline {
            inherit
              pkgs
              registry
              defaultRoot
              vars
              ;

            bake = bake.lib;
            root = ./.;
            extraImageRoots = [ ./images ];
          };
        in
        niximiuz.mkPackages { inherit pkgs content; };
    in
    {
      inherit bakeModules;

      lib = {
        inherit bakeModules;
      };

      packages = forAllSystems ({ pkgs, ... }: packagesFor pkgs);

      checks = forAllSystems ({ pkgs, ... }: packagesFor pkgs);

      devShells = forAllSystems (
        { pkgs, ... }:
        {
          default = pkgs.mkShell {
            packages = [
              pkgs.just
              pkgs.labctl
              pkgs.yq-go
            ];
          };
        }
      );
    };
}

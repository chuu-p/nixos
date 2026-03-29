{
  description = "cluster laghima configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-wsl.url = "github:nix-community/NixOS-WSL";
  };

  outputs = { self, nixpkgs, deploy-rs, ... }@inputs:

  let
    lib = nixpkgs.lib;

    hosts = {
      jinora = {
        system = "aarch64-linux";
        hostname = "jinora";
        user = "root";
      };

      toph = {
        system = "aarch64-linux";
        hostname = "toph";
        user = "root";
      };

      iroh = {
        system = "aarch64-linux";
        hostname = "iroh";
        user = "root";
      };

      opal = {
        system = "aarch64-linux";
        hostname = "opal";
        user = "root";
      };

      baumeyster = {
        system = "x86_64-linux";
        hostname = "MellikapertPC";
        user = "chuu";
      };
    };

  in
  {

    nixosConfigurations =
      lib.mapAttrs
      (name: cfg:
        lib.nixosSystem {
          system = cfg.system;
          specialArgs = inputs;
          modules = [ ./hosts/${name}.nix ];
        })
      hosts;


    deploy.nodes =
      lib.mapAttrs
      (name: cfg: {
        hostname = cfg.hostname;

        profiles.system = {
          user = cfg.user;
          path =
            deploy-rs.lib.${cfg.system}.activate.nixos
            self.nixosConfigurations.${name};
        };
      })
      hosts;


    checks =
      builtins.mapAttrs
      (system: deployLib: deployLib.deployChecks self.deploy)
      deploy-rs.lib;

  };
}

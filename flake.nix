{
  description = "cluster laghima + workstations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager?ref=release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix4nvchad = {
      url = "github:nix-community/nix4nvchad";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:nix-community/stylix/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    musnix = {
      url = "github:musnix/musnix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    deploy-rs,
    home-manager,
    stylix,
    musnix,
    nixos-hardware,
    nixos-wsl,
    sops-nix,
    ...
  } @ inputs: let
    lib = nixpkgs.lib;
    hosts = {
      jinora = {
        system = "aarch64-linux";
        hostname = "jinora";
        user = "root";
        modules = [./hosts/jinora.nix];
      };
      toph = {
        system = "aarch64-linux";
        hostname = "toph";
        user = "root";
        modules = [./hosts/toph.nix];
      };
      iroh = {
        system = "aarch64-linux";
        hostname = "iroh";
        user = "root";
        modules = [./hosts/iroh.nix];
      };
      opal = {
        system = "aarch64-linux";
        hostname = "opal";
        user = "root";
        modules = [./hosts/opal.nix];
      };
      baumeyster = {
        system = "x86_64-linux";
        hostname = "MellikapertPC";
        user = "chuu";
        modules = [
          nixos-wsl.nixosModules.wsl
          ./hosts/baumeyster.nix
        ];
      };
      g14 = {
        system = "x86_64-linux";
        hostname = "g14";
        user = "root";
        modules = [
          musnix.nixosModules.musnix
          stylix.nixosModules.stylix
          sops-nix.nixosModules.sops

          nixos-hardware.nixosModules.asus-zephyrus-ga401
          ./hosts/g14/g14.nix
          ./hosts/g14/g14-hardware.nix

          home-manager.nixosModules.home-manager
          {
            home-manager = {
              extraSpecialArgs = {inherit inputs;};
            };
          }
          {
            home-manager.backupFileExtension = "hm-backup";
            home-manager.users.chuu.imports = [
              ./homes/chuu/home.nix
            ];
          }
        ];
      };
      varrick = {
        system = "x86_64-linux";
        hostname = "varrick";
        user = "root";

        modules = [
          musnix.nixosModules.musnix
          stylix.nixosModules.stylix

          ./hosts/varrick/varrick.nix
          ./hosts/varrick/varrick-hardware.nix

          home-manager.nixosModules.home-manager
          {
            home-manager = {
              extraSpecialArgs = {inherit inputs;};
            };
            nixpkgs.config.allowBroken = true;
          }

          {
            home-manager.backupFileExtension = "hm-backup";
            home-manager.users.chuu.imports = [
              ./homes/chuu/home.nix
            ];
          }
        ];
      };
    };
  in {
    nixosConfigurations =
      lib.mapAttrs
      (name: cfg:
        lib.nixosSystem {
          system = cfg.system;
          specialArgs = inputs // {inherit inputs;};
          modules =
            cfg.modules
            ++ [
              {
                nixpkgs.overlays = [
                  (final: prev: {
                    unstable = import inputs.nixpkgs-unstable {
                      system = prev.system;
                      config.allowUnfree = true;
                    };
                  })
                ];
              }
            ];
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

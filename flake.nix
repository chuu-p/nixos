{
  description = "g14";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs?ref=nixos-unstable";
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
    nixos-hardware = {
      url = "github:NixOS/nixos-hardware/master";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    stylix,
    musnix,
    nixos-hardware,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    lib = nixpkgs.lib;
  in {
    nixosConfigurations = {
      g14 = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit system inputs;
        };
        system = "x86_64-linux";
        modules = [
          musnix.nixosModules.musnix
          stylix.nixosModules.stylix

          nixos-hardware.nixosModules.asus-zephyrus-ga401
          ./hosts/g14/g14.nix
          ./hosts/g14/g14-hardware.nix

          home-manager.nixosModules.home-manager
          {
            home-manager = {
              extraSpecialArgs = {
                inherit system inputs;
              };
            };
          }
          {
            home-manager.backupFileExtension = "hm-backup";
            home-manager.users.chuu = {
              imports = [
                ./homes/chuu/home.nix
              ];
            };
          }
        ];
      };
      varrick = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit system inputs;
        };
        system = "x86_64-linux";
        modules = [
          musnix.nixosModules.musnix
          stylix.nixosModules.stylix

          ./hosts/varrick/varrick.nix
          ./hosts/varrick/varrick-hardware.nix

          home-manager.nixosModules.home-manager
          {
            home-manager = {
              extraSpecialArgs = {
                inherit system inputs;
              };
            };
            nixpkgs.config.allowBroken = true;
          }
          {
            home-manager.backupFileExtension = "hm-backup";
            home-manager.users.chuu = {
              imports = [
                ./homes/chuu/home.nix
              ];
            };
          }
        ];
      };
    };
  };
}

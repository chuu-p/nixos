{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";

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
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    stylix,
    nixos-wsl,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    lib = nixpkgs.lib;
  in {
    nixosConfigurations = {
      p14s = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit system inputs;
        };
        system = "x86_64-linux";
        modules = [
          nixos-wsl.nixosModules.default
          {
            system.stateVersion = "25.05";
            wsl.enable = true;
          }
          musnix.nixosModules.musnix
          stylix.nixosModules.stylix
          ./configuration.nix
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

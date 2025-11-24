{
  description = "g14";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix4nvchad = {
      url = "github:nix-community/nix4nvchad";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixowos = {
      url = "github:yunfachi/nixowos";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    lib = nixpkgs.lib;
  in {
    nixosConfigurations.g14 = nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit system inputs;
      };
      system = "x86_64-linux";
      modules = [
        ./configuration.nix

        # Add nixowos system module
        inputs.nixowos.nixosModules.default

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
              # Add nixowos home module if you want it available in user configs
              inputs.nixowos.homeModules.default
              ./home.nix
            ];
          };
        }
      ];
    };
  };
}

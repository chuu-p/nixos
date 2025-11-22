{
  description = "g14";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.05";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix4nvchad = {
      url = "github:nix-community/nix4nvchad";
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
            home = {
              shellAliases = {
                l = "ls -alh";
                ll = "ls -l";
                ls = "ls --color=tty";
                kubectl = "sudo k3s kubectl";
                sudo = "sudo ";
                prettier = "npx prettier --write";
                g = "git";
                cg = "cargo";
                j = "just";
                zj = "zellij";
              };
            };
            imports = [
              ./home.nix
            ];
          };
        }
      ];
    };
  };
}

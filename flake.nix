{
  description = "g14";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
  }: {
    nixosConfigurations.g14 = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
        home-manager.nixosModules.home-manager
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
              ./home.nix # We'll create this file later
            ];
          };
        }
      ];
    };
  };
}

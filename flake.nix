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
        ./hyper/flake.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.users.chuu = {
            imports = [
              ./home.nix # We'll create this file later
            ];
          };
        }
      ];
    };
  };
}

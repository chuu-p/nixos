{
  inputs.nixpkgs.url = github:NixOS/nixpkgs/nixos-unstable;

  outputs = {
    self,
    nixpkgs,
  }: {
    nixosConfigurations.bolin = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        (nixpkgs + "/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix")
        ./configuration.nix
      ];
    };
  };
}

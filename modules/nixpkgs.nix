{
  inputs,
  pkgs,
  ...
}: {
  nixpkgs = {
    config = {
      allowUnfree = true;
      allowBroken = true;
      permittedInsecurePackages = [
        "electron-39.8.10"
        "pnpm-9.15.9"
      ];
    };
    overlays = [
      (final: prev: {
        nvchad = inputs.nix4nvchad.packages."${pkgs.stdenv.hostPlatform.system}".nvchad;
        unstable = import inputs.nixpkgs-unstable {
          inherit (final.stdenv.hostPlatform) system;
          inherit (final) config;
        };
      })
      (final: prev: {
        linuxPackages = prev.linuxPackages // {
          openrazer = final.unstable.linuxPackages.openrazer;
        };
      })
    ];
  };
}

{
  config,
  pkgs,
  ...
}: {
  imports = [
    <nixos-hardware/asus/zephyrus/ga401>
    ./hardware-configuration.nix
    ./g14.nix
  ];
}

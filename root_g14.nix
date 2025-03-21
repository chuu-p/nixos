{ config, pkgs, ... }:

{
  imports =
    [
      <nixos-hardware/asus/zephyrus/ga401>      
      ./hardware-configuration.nix
      /home/chuu/git/nixos/g14.nix
    ];
}

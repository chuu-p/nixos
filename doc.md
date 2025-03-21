How to install nixos on rog zephyrus g14 (or any pc/laptop with a nvidia graphics card)

download iso
flash iso
reboot into iso
choose "nomodeset" or sth

~~~sh
# mount drives and enter nixos
sudo mount /dev/nvme0n3 /mnt
sudo mount /dev/nvme0n1 /mnt/boot
sudo nixos-enter

sudo nano /etc/nixos/configuration.nix
# add this line:
# boot.kernelParams = [ "nomodeset" ];
sudo nixos-rebuild switch
# now blackscreen is fixed, but the hardware it is not optimally configured yet

# reboot into
sudo reboot

# install nixos hardware 
# https://github.com/NixOS/nixos-hardware
sudo nix-channel --add https://github.com/NixOS/nixos-hardware/archive/master.tar.gz nixos-hardware
sudo nix-channel --update
sudo nano /etc/nixos/configuration.nix
# imports = [
#   <nixos-hardware/asus/zephyrus/ga401>
#   ./hardware-configuration.nix
# ];
sudo nixos-rebuild switch
# you can ignore the following error: could not start nvidia power service
sudo reboot
~~~

now, it should work!


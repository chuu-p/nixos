{
  description = "opal Raspberry Pi 5 configuration flake";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixos-raspberrypi.url = "github:nvmd/nixos-raspberrypi/main";
  };

  nixConfig = {
    extra-substituters = [
      "https://nixos-raspberrypi.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nixos-raspberrypi.cachix.org-1:4iMO9LXa8BqhU+Rpg6LQKiGa2lsNh/j2oiYLNOQ5sPI="
    ];
  };

  outputs = {
    self,
    nixpkgs,
    nixos-raspberrypi,
  } @ inputs: {
    nixosConfigurations = {
      opal = nixos-raspberrypi.lib.nixosSystem {
        specialArgs = inputs;
        modules = [
          ({...}: {
            imports = with nixos-raspberrypi.nixosModules; [
              raspberry-pi-4.base
              raspberry-pi-4.bluetooth
            ];
          })
          ({...}: {
            networking.hostName = "opal";
            services.openssh = {
              enable = true;
              settings.PasswordAuthentication = false; # Disable password-based SSH login for security
              settings.PermitRootLogin = "prohibit-password"; # Allow root login only with a key
              banner = ''
                █▀█ █▀█ ▄▀█ █░░
                █▄█ █▀▀ █▀█ █▄▄
                Protection and power
                are overrated.
                Choose happiness and love.
              '';
            };

            nix.settings = {
              # keep cache.nixos.org implicitly; add the raspberrypi cachix
              extra-substituters = [
                "https://nixos-raspberrypi.cachix.org"
              ];

              # the public key you already listed in your flake inputs:
              extra-trusted-public-keys = [
                "nixos-raspberrypi.cachix.org-1:4iMO9LXa8BqhU+Rpg6LQKiGa2lsNh/j2oiYLNOQ5sPI="
              ];
            };

            users.users.chuu = {
              isNormalUser = true;
              password = "chuu";
              extraGroups = ["networkmanager" "wheel" "docker"];
              openssh.authorizedKeys.keys = [
                "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHQHb+VwHnS97Wmu4xpUDlLhzB+Ip11BINatUivsr6+a"
              ];
            };

            users.users.root.openssh.authorizedKeys.keys = [
              "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHQHb+VwHnS97Wmu4xpUDlLhzB+Ip11BINatUivsr6+a"
            ];

            security.sudo.extraRules = [
              {
                users = ["chuu"];
                commands = [
                  {
                    command = "ALL";
                    options = ["NOPASSWD"];
                  }
                ];
              }
            ];

            nix.settings = {
              trusted-users = ["root" "@wheel" "chuu"];
              experimental-features = ["nix-command" "flakes"];
            };

            nixpkgs.config.allowUnfree = true;
          })

          ({...}: {
            fileSystems = {
              "/boot/firmware" = {
                device = "/dev/disk/by-uuid/2175-794E";
                fsType = "vfat";
                options = [
                  "noatime"
                  "noauto"
                  "x-systemd.automount"
                  "x-systemd.idle-timeout=1min"
                ];
              };
              "/" = {
                device = "/dev/disk/by-uuid/44444444-4444-4444-8888-888888888888";
                fsType = "ext4";
                options = ["noatime"];
              };
            };
          })
        ];
      };
    };
  };
}

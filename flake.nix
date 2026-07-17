{
  description = "cluster laghima + workstations";

  nixConfig = {
    extra-substituters = [
      "https://nixos-raspberrypi.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nixos-raspberrypi.cachix.org-1:4iMO9LXa8BqhU+Rpg6LQKiGa2lsNh/j2oiYLNOQ5sPI="
    ];
  };

  inputs = {
    nixpkgs.follows = "nixos-raspberrypi/nixpkgs";
    nixpkgs-unstable.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager?ref=release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix4nvchad = {
      url = "github:nix-community/nix4nvchad";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:nix-community/stylix/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    musnix = {
      url = "github:musnix/musnix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-on-droid = {
      url = "github:nix-community/nix-on-droid/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-raspberrypi = {
      url = "github:nvmd/nixos-raspberrypi";
    };
  };

  outputs = {
    self,
    nixpkgs,
    deploy-rs,
    home-manager,
    stylix,
    musnix,
    nixos-hardware,
    nixos-wsl,
    sops-nix,
    nix-on-droid,
    nixos-raspberrypi,
    ...
  } @ inputs: let
    lib = nixpkgs.lib;
    hosts = {
      jinora = {
        system = "aarch64-linux";
        hostname = "jinora";
        user = "root";
        modules = [./hosts/jinora.nix];
      };
      toph = {
        system = "aarch64-linux";
        hostname = "toph";
        user = "root";
        modules = [./hosts/toph.nix];
      };
      iroh = {
        system = "aarch64-linux";
        hostname = "iroh";
        user = "root";
        modules = [./hosts/iroh.nix];
      };
      opal = {
        system = "aarch64-linux";
        hostname = "opal";
        user = "root";
        modules = [./hosts/opal.nix];
      };
      baumeyster = {
        system = "x86_64-linux";
        hostname = "nixos-wsl";
        user = "chuu";
        modules = [
          nixos-wsl.nixosModules.wsl
          ./hosts/baumeyster.nix
        ];
      };
      g14 = {
        system = "x86_64-linux";
        hostname = "g14";
        user = "root";
        modules = [
          musnix.nixosModules.musnix
          stylix.nixosModules.stylix
          sops-nix.nixosModules.sops

          nixos-hardware.nixosModules.asus-zephyrus-ga401
          ./hosts/g14/g14.nix
          ./hosts/g14/g14-hardware.nix

          home-manager.nixosModules.home-manager
          {
            home-manager = {
              extraSpecialArgs = {inherit inputs;};
            };
          }
          {
            home-manager.backupFileExtension = "hm-backup";
            home-manager.users.chuu.imports = [
              ./homes/chuu/home.nix
            ];
          }
        ];
      };
      varrick = {
        system = "x86_64-linux";
        hostname = "varrick";
        user = "root";

        modules = [
          musnix.nixosModules.musnix
          stylix.nixosModules.stylix

          ./hosts/varrick/varrick.nix
          ./hosts/varrick/varrick-hardware.nix

          home-manager.nixosModules.home-manager
          {
            home-manager = {
              extraSpecialArgs = {inherit inputs;};
            };
            nixpkgs.config.allowBroken = true;
          }

          {
            home-manager.backupFileExtension = "hm-backup";
            home-manager.users.chuu.imports = [
              ./homes/chuu/home.nix
            ];
          }
        ];
      };
    };
  in {
    nixosConfigurations =
      (lib.mapAttrs
        (name: cfg:
          lib.nixosSystem {
            system = cfg.system;
            specialArgs = inputs // {inherit inputs;};
            modules =
              cfg.modules
              ++ [
                {
                  nixpkgs.overlays = [
                    (final: prev: {
                      unstable = import inputs.nixpkgs-unstable {
                        system = prev.system;
                        config = final.config // {
                          allowUnfree = true;
                        };
                      };
                    })
                  ];
                }
              ];
          })
        hosts)
      // {
        # Raspberry Pi Zero 2 W installer with pre-configured WiFi and SSH
        rpi02-wifi = nixos-raspberrypi.lib.nixosInstaller {
          specialArgs = inputs;
          modules = [
            {
              imports = with nixos-raspberrypi.nixosModules; [
                raspberry-pi-02.base
                usb-gadget-ethernet
              ];
            }
            {
              services.openssh.settings.PermitRootLogin = "prohibit-password";
              users.users.root.openssh.authorizedKeys.keys = [
                "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHQHb+VwHnS97Wmu4xpUDlLhzB+Ip11BINatUivsr6+a"
              ];
              users.users.nixos.openssh.authorizedKeys.keys = [
                "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHQHb+VwHnS97Wmu4xpUDlLhzB+Ip11BINatUivsr6+a"
              ];
            }
            {
              networking.networkmanager.enable = lib.mkForce false;
              networking.wireless.enable = true;
              networking.wireless.networks = {
                "FRITZ!Box 7583 UJ" = {
                  psk = "41808552962347953265";
                };
              };
              hardware.bluetooth.enable = true;
            }
            # ({pkgs, ...}: {
            #   environment.systemPackages = with pkgs; [
            #     vim
            #     # yazi
            #     git
            #     ydotool
            #   ];
            # })
          ];
        };
      };
    nixOnDroidConfigurations = {
      op9pro = nix-on-droid.lib.nixOnDroidConfiguration {
        pkgs = import nixpkgs {
          system = "aarch64-linux";
          config.allowUnfree = true;
        };
        modules = [./hosts/op9pro/default.nix];
        extraSpecialArgs = {inherit inputs;};
      };
      astryd = nix-on-droid.lib.nixOnDroidConfiguration {
        pkgs = import nixpkgs {
          system = "aarch64-linux";
          config.allowUnfree = true;
        };
        modules = [./hosts/astryd/default.nix];
        extraSpecialArgs = {inherit inputs;};
      };
    };
    deploy.nodes =
      (lib.mapAttrs
        (name: cfg: {
          hostname = cfg.hostname;

          profiles.system = {
            user = cfg.user;

            path =
              deploy-rs.lib.${cfg.system}.activate.nixos
              self.nixosConfigurations.${name};
          };
        })
        hosts)
      // {
        op9pro = {
          hostname = "oneplus-9-pro";
          sshPort = 8022;
          fastConnection = true;
          autoRollback = false;
          magicRollback = false;
          profiles.system = {
            sshUser = "nix-on-droid";
            user = "nix-on-droid";
            path =
              deploy-rs.lib.x86_64-linux.activate.custom
              (import nixpkgs {system = "x86_64-linux";}).runCommand "op9pro" {} "mkdir \$out"
              ''
                nix-on-droid switch --flake github:chuu-p/nixos#op9pro
              '';
          };
        };
        astryd = {
          hostname = "Pixel-10";
          sshPort = 8022;
          fastConnection = true;
          autoRollback = false;
          magicRollback = false;
          profiles.system = {
            sshUser = "nix-on-droid";
            user = "nix-on-droid";
            path =
              deploy-rs.lib.x86_64-linux.activate.custom
              (import nixpkgs {system = "x86_64-linux";}).runCommand "astryd" {} "mkdir \$out"
              ''
                nix-on-droid switch --flake github:chuu-p/nixos#astryd
              '';
          };
        };
      };
    checks =
      builtins.mapAttrs
      (system: deployLib: deployLib.deployChecks self.deploy)
      deploy-rs.lib;

    installerImages.rpi02-wifi =
      self.nixosConfigurations.rpi02-wifi.config.system.build.sdImage;
  };
}

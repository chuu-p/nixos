{...}: {
  nix = {
    gc = {
      # collect garbage automatically, every week
      automatic = true;
      dates = "weekly";
      # keep store blobs for old generations up to 30 days
      options = "--delete-older-than 30d";
    };
    settings = {
      # deduplicate store files
      auto-optimise-store = true;
      experimental-features = ["nix-command" "flakes"];
      trusted-users = ["root" "@wheel" "chuu"];
      extra-platforms = ["aarch64-linux"];
      extra-substituters = [
        "https://devenv.cachix.org"
        "https://nixos-raspberrypi.cachix.org"
      ];
      extra-trusted-public-keys = [
        "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
        "nixos-raspberrypi.cachix.org-1:4iMO9LXa8BqhU+Rpg6LQKiGa2lsNh/j2oiYLNOQ5sPI="
      ];
    };
    # TODO: migrate extraOptions below into settings above
    extraOptions = "";
    distributedBuilds = true;
    buildMachines = [
      {
        hostName = "jinora";
        sshUser = "chuu";
        system = "aarch64-linux";
        protocol = "ssh-ng";
        maxJobs = 1;
        speedFactor = 2;
        supportedFeatures = ["nixos-test" "benchmark" "big-parallel" "kvm"];
        mandatoryFeatures = [];
      }
      {
        hostName = "iroh";
        sshUser = "chuu";
        system = "aarch64-linux";
        protocol = "ssh-ng";
        maxJobs = 1;
        speedFactor = 2;
        supportedFeatures = ["nixos-test" "benchmark" "big-parallel" "kvm"];
        mandatoryFeatures = [];
      }
      {
        hostName = "opal";
        sshUser = "chuu";
        system = "aarch64-linux";
        protocol = "ssh-ng";
        maxJobs = 1;
        speedFactor = 4;
        supportedFeatures = ["nixos-test" "benchmark" "big-parallel" "kvm"];
        mandatoryFeatures = [];
      }
      {
        hostName = "toph";
        sshUser = "chuu";
        system = "aarch64-linux";
        protocol = "ssh-ng";
        maxJobs = 1;
        speedFactor = 4;
        supportedFeatures = ["nixos-test" "benchmark" "big-parallel" "kvm"];
        mandatoryFeatures = [];
      }
      # {
      #   hostName = "nixos-wsl";
      #   sshUser = "chuu";
      #   systems = ["x86_64-linux" "aarch64-linux"];
      #   protocol = "ssh-ng";
      #   maxJobs = 6;
      #   speedFactor = 10;
      #   supportedFeatures = ["nixos-test" "benchmark" "big-parallel" "kvm"];
      #   mandatoryFeatures = [];
      # }
    ];
  };
}

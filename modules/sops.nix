{ config, ... }: {
  sops = {
    age.sshKeyPaths = ["/home/chuu/.ssh/id_ed25519"];
    defaultSopsFile = ../secrets/example.yaml;
    secrets = {
      "api-key" = {};
      "nextcloud-admin" = {};
    };
  };
}

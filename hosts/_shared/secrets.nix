{...}: {
  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    age.keyFile = "/home/chuu/.config/sops/age/keys.txt";
  };
}

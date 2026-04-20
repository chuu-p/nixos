{
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    (vscode-with-extensions.override {
      vscode = antigravity; # vscodium;
      vscodeExtensions = with vscode-extensions;
        [
          bierner.emojisense
          jnoortheen.nix-ide
          rust-lang.rust-analyzer
          streetsidesoftware.code-spell-checker
          streetsidesoftware.code-spell-checker-german
          tamasfe.even-better-toml
          vadimcn.vscode-lldb
          vscodevim.vim
          redhat.vscode-yaml
        ]
        ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
          {
            name = "fluent-oled";
            publisher = "fermeridamagni";
            version = "1.0.1";
            sha256 = "ntB4yL9EUxsamPc81OFuoUsFGdh5+Ljg75GjrLP7xqw=";
          }
        ];
    })
  ];
}

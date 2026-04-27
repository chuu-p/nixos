{
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    (vscode-with-extensions.override {
      vscode = unstable.antigravity; # vscodium;
      vscodeExtensions = with vscode-extensions;
        [
          # vscodevim.vim
          asvetliakov.vscode-neovim
          bierner.emojisense
          foam.foam-vscode
          jnoortheen.nix-ide
          redhat.vscode-yaml
          rust-lang.rust-analyzer
          streetsidesoftware.code-spell-checker
          streetsidesoftware.code-spell-checker-german
          tamasfe.even-better-toml
          vadimcn.vscode-lldb
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

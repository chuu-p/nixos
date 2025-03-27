{
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = [
    (let
      pname = "hyper";
      version = "3.4.1";
      src = pkgs.fetchurl {
        url = "https://github.com/vercel/hyper/releases/download/v3.4.1/Hyper-3.4.1.AppImage";
        sha256 = "sha256-UFC+Zn/lbWhx7W+Gs7A6AjsrdaqRMpqCwvFf9+1mtjw=";
      };
      appimageContents = pkgs.appimageTools.extractType2 {inherit pname version src;};
    in
      pkgs.appimageTools.wrapType2 {
        inherit pname version src;
        extraInstallCommands = ''
          install -m 444 -D ${appimageContents}/hyper.desktop $out/share/applications/hyper.desktop
          install -m 444 -D ${appimageContents}/hyper.png $out/share/icons/hicolor/512x512/apps/hyper.png
          substituteInPlace $out/share/applications/hyper.desktop \
            --replace 'Exec=AppRun' 'Exec=${pname}'
        '';
      })
  ];
}

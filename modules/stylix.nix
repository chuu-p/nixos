{pkgs, ...}: {
  stylix = {
    enable = true;
    autoEnable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/evenok-dark.yaml";
    # base16Scheme = "${pkgs.base16-schemes}/share/themes/tarot.yaml";
    # base16Scheme = "${pkgs.base16-schemes}/share/themes/chalk.yaml";
    polarity = "dark";
    image = ../aesthetics/space_bg.png;
    fonts = {
      serif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Serif";
      };
      sansSerif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Sans";
      };
      monospace = {
        package = pkgs.nerd-fonts.space-mono;
        name = "Space Mono";
      };
      emoji = {
        package = pkgs.noto-fonts-color-emoji;
        name = "Noto Color Emoji";
      };
    };
  };
}

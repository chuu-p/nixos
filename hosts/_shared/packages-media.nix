{
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    ardour # linux daw
    blender # 3d modeling
    ffmpeg # multimedia toolkit
    ghostscript # for imagemagick pdf processing
    gimp # image manipulation
    godot # make games
    imagemagick # image magick
    inkscape # vector image manipulation
    libreoffice # nice to have office suite
    shotcut # video editor
  ];
}

{ config, pkgs, ... }:

{
  home.packages = [ pkgs.grim pkgs.slurp pkgs.swappy ];

  xdg.configFile."swappy/config".text = ''
    [Default]
    save_dir=/home/ll/Pictures
    save_filename_format=screenshot-%Y%m%d-%H%M%S.png
    show_panel=true
    line_size=5
    text_size=20
    text_font=sans-serif
    paint_mode=brush
    early_exit=false
    fill_shape=false
  '';
}

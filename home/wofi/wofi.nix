{config, pkgs, ... }:

{
  programs.wofi = {
      enable = true;
      settings = {
        show = "drun";
        width = 400;
        lines = 5;
        location = "top";
        yoffset = 150;
        allow_images = true; # This enables the icons
        hide_scroll = true;
        insensitive = true;
        prompt = "Search...";
      };
      style = builtins.readFile ./style.css;
    };
}
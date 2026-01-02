{config,lib, pkgs, inputs, stable, hyprland, ... }:
{
  home.username = "musa";
  home.homeDirectory = "/home/musa";
  home.stateVersion = "25.11";
  programs.firefox.enable = true;

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "ImBored7820";
	email = "mohammedmusaali549@gmail.com";
      };
    };
  };

  programs.kitty.enable = true;

  # Packages
  home.packages = with pkgs; [
    # Main
    discord
    spotify
    waybar
    dunst
    hyprpaper
    hyprcursor
    hyprlauncher
    hyprlock
    hypridle
    hyprpicker
    hyprsunset
    hyprsysteminfo
    hyprpolkitagent
    hyprland-protocols
    hyprland-qtutils

  ];
}

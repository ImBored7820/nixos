{config,lib, pkgs, inputs, stable, hyprland, spicetify-nix, ... }:


  let
    spicePkgs = spicetify-nix.legacyPackages.${pkgs.system};
  in
  {
    imports = [
      ./home/waybar/waybar.nix
      ./home/kitty.nix
      ./home/hypr/hyprpaper.nix
      ./home/hypr/hyprland.nix
      ./home/wofi/wofi.nix
      spicetify-nix.homeManagerModules.default
    ];
    
    home.username = "musa";
    home.homeDirectory = "/home/musa";
    home.stateVersion = "25.11";

    #home.file.".config/nwg-dock-hyprland/style.css".source = ./home/nwg/style.css;

    #home.file.".config/nwg-drawer/style.css".source = ./home/nwg/drawer.css;

    # Packages
    home.packages = with pkgs; [
      # Main
      discord
      #spotify
      brave
      nautilus
      jetbrains.idea
      pkgs.jdk25
      waybar
      nwg-dock-hyprland
      nwg-drawer
      dunst
      hyprpaper
      hyprcursor
      hyprlock
      hypridle
      hyprpicker
      hyprsunset
      hyprsysteminfo
      hyprpolkitagent
      hyprland-protocols
      hyprland-qtutils
      kdePackages.breeze-icons
    ];

    # Settings
   
    programs.git = {
      enable = true;
      settings = {
        user = {
          name = "ImBored7820";
          email = "mohammedmusaali549@gmail.com";
        };
      };
    };

    programs.spicetify = {
      enable = true;
      enabledExtensions = with spicePkgs.extensions; [
        adblockify
        hidePodcasts
        shuffle
      ];
      theme = spicePkgs.themes.catppuccin;
      colorScheme = "mocha";
    };

    home.sessionVariables = {
      _JAVA_AWT_WM_NONREPARENTING = "1";
      "-Dwayland.enabled" = "true";
      GDK_SCALE = "1.5";
      "_JAVA_OPTIONS" = "-Dsun.java2d.uiScale=1.5";
    };
}

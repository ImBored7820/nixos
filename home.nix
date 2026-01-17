{config, lib, pkgs, inputs, hyprland, nix-flatpak, spicetify-nix, ... }:

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
      nix-flatpak.homeManagerModules.nix-flatpak
    ];
    
    home.username = "musa";
    home.homeDirectory = "/home/musa";
    home.stateVersion = "25.11";

    #home.file.".config/nwg-dock-hyprland/style.css".source = ./home/nwg/style.css;
    #home.file.".config/nwg-drawer/style.css".source = ./home/nwg/drawer.css;
  
    # Packages
    home.packages = with pkgs; [
      # Main
      adwaita-icon-theme
      discord
      prismlauncher
      nautilus
      jetbrains.idea
      nwg-dock-hyprland
      nwg-drawer
      dunst
      hyprpaper
      hyprcursor
      hyprlock
      hypridle
      hyprpicker
      hyprsunset
      hyprshot
      hyprsysteminfo
      hyprpolkitagent
      hyprland-protocols
      hyprland-qtutils
      neovim 
      wget
      kitty
      fastfetch
      btop
      wl-clipboard
      libinput
      hyprpolkitagent
      # Linux-Surface
      surface-control
      linux-firmware
      #Ctls
      brightnessctl
      playerctl
      sbctl
      # Misc
      cachix
      zoom-us
      powershell
    ];

  programs.java = {
    enable = true;
    package = pkgs.jdk25;
  };

  home.pointerCursor = {
    gtk.enable = true;
    # x11.enable = true; # Uncomment if you use X11 instead of Wayland
    package = pkgs.adwaita-icon-theme;
    name = "Adwaita";
    size = 32; # Larger size helps with 150% scaling
  };

  dconf.settings = {
  "org/gnome/mutter" = {
    experimental-features = [ "scale-monitor-framebuffer" "xwayland-native-scaling" ];
  };
};

    # Settings
    services.flatpak = {
      enable = true;
      packages = ["app.zen_browser.zen"];
    };
    
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

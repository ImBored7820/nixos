{ config, lib, pkgs, inputs, unstable, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
      # This imports the Surface kernel patches automatically
      #inputs.nixos-hardware.nixosModules.microsoft-surface-common 
    ];

  # --- BOOT & KERNEL ---
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.kernelModules = [ "i915" ]; # Keep this for Intel Graphics
  boot.kernelParams = [ 
  "i915.enable_guc=3" 
  "i915.enable_fbc=1" 
  ];
  
  # --- FLAKE A1 ---
  nix.settings = {
    # enable flakes and nix-command (if not globally set already)
     experimental-features = [ "nix-command" "flakes" ];

     # Use the normal Nix cache + the linux-surface Cachix (avoids hours of local kernel builds)
     substituters = [
       "https://cache.nixos.org/"
       "https://linux-surface.cachix.org"
       "https://hyprland.cachix.org"
     ];

     trusted-public-keys = [
       # default cache key (cache.nixos.org)
       "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
       # linux-surface cachix public key (from the linux-surface cache owner)
       # (if you prefer, you can use `cachix use linux-surface` instead of adding keys manually)
       "linux-surface.cachix.org-1:pne97K2ML9alAtzzVvmoS4G8HWIeyvP4nNfS79vS7Sg="
       "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
     ];
   };


  # --- GRAPHICS ---
  hardware.graphics = {
   enable = true;
   enable32Bit = true;
   package = unstable.mesa;
   extraPackages = with pkgs; [
    intel-media-driver # Better for modern Intel GPUs (Iris Plus)
    libvdpau-va-gl
    vaapiVdpau
    ];
  };
  
  # --- HYPRLAND ---
  xdg.portal.enable = true;
  programs.hyprland = {
   enable = true;
   package = unstable.hyprland;
   portalPackage = unstable.xdg-desktop-portal-hyprland; # Tell Hyprland to use unstable
   };
  security.polkit.enable = true;
  services.dbus.enable = true;
  
  
  # --- GNOME ---

  # services.xserver.enable = true;
  # services.xserver.displayManager.gdm.enable = true;
  # services.xserver.desktopManager.gnome.enable = true;

  
  # --- ENVIRONMENT ---
  environment.sessionVariables = {
   # REMOVE THIS: WLR_NO_HARDWARE_CURSORS = "1"; 
   # It causes lag/crashes on Intel Surface. Only use if cursor is invisible.
   NIXOS_OZONE_WL = "1"; # Forces apps like VSCode/Discord to use Wayland
   NIX_PROXIES_FOR_OPENGL = "1";
  };

  # --- PACKAGES ---
  users.users.musa = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "input" ];
    packages = with pkgs; [
      tree
    ];
  };

   # --- PACKAGES (System) --- 
   programs.firefox.enable = true;	
   environment.systemPackages = with pkgs; [
    # Functionality 
    neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    unstable.kitty
    fastfetch
    btop
    git
    foot
    # Utilities 
    wl-clipboard
    libinput
    # Linux-Surface
    surface-control
    linux-firmware
    # Main Apps
    discord
    spotify
    # Hypr-Ecosystem
    hyprpaper
    hyprcursor
    unstable.hyprlauncher
    hyprlock
    hypridle
    # Misc
    plymouth
    ];
  
  # --- SYSTEM ---
  environment.variables.EDITOR = "neovim";
  # networking, timezone, and stateVersion settings
  hardware.enableAllFirmware = true;
  networking.hostName = "MusaNixos"; # Define your hostname.

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";
  system.stateVersion = "24.11"; # Keep this as is!
}





























# # Edit this configuration file to define what should be installed on
# # your system. Help is available in the configuration.nix(5) man page, on
# # https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
#
# { config, lib, pkgs, inputs, ... }:
#
# {
#   imports =
#     [ # Include the results of the hardware scan.
#       ./hardware-configuration.nix
#     ];
#
#   # Use the systemd-boot EFI boot loader.
#   boot.loader.systemd-boot.enable = true;
#   boot.loader.efi.canTouchEfiVariables = true;
#   boot.initrd.kernelModules = [ "i915" ];
#    environment.sessionVariables = {
#   WLR_NO_HARDWARE_CURSORS = "1";
# };
# services.seatd.enable = true;
#
#     nixpkgs.config.allowUnfree = true;
#
# hardware.graphics = {
# 	enable = true;
# 	enable32Bit = true;
# 	};
#
#   # Use latest kernel.
#
#   #boot.kernelPackages = pkgs.linuxPackages_latest;
#   hardware.enableAllFirmware = true;
#  networking.hostName = "MusaNixos"; # Define your hostname.
#
#   # Configure network connections interactively with nmcli or nmtui.
#   networking.networkmanager.enable = true;
#
#   # Set your time zone.
#   time.timeZone = "America/Los_Angeles";
#
#   # Configure network proxy if necessary
#   # networking.proxy.default = "http://user:password@proxy:port/";
#   # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
#
#   # Select internationalisation properties.
#   # i18n.defaultLocale = "en_US.UTF-8";
#   # console = {
#   #   font = "Lat2-Terminus16";
#   #   keyMap = "us";
#   #   useXkbConfig = true; # use xkb.options in tty.
#   # };
#
#   # Enable the X11 windowing system.
#  services.xserver.enable = true;
#  services.xserver.displayManager.gdm.enable = true;
#  services.xserver.desktopManager.gnome.enable = true;
#
#
#
#
#
#
#
#
#   nix.settings = {
#     # enable flakes and nix-command (if not globally set already)
#     experimental-features = [ "nix-command" "flakes" ];
#
#     # Use the normal Nix cache + the linux-surface Cachix (avoids hours of local kernel builds)
#     substituters = [
#       "https://cache.nixos.org/"
#       "https://linux-surface.cachix.org"
#       "https://hyprland.cachix.org"
#     ];
#
#     trusted-public-keys = [
#       # default cache key (cache.nixos.org)
#       "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
#       # linux-surface cachix public key (from the linux-surface cache owner)
#       # (if you prefer, you can use `cachix use linux-surface` instead of adding keys manually)
#       "linux-surface.cachix.org-1:pne97K2ML9alAtzzVvmoS4G8HWIeyvP4nNfS79vS7Sg="
#       "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
#     ];
#   };
#
#   # Configure keymap in X11
#   # services.xserver.xkb.layout = "us";
#   # services.xserver.xkb.options = "eurosign:e,caps:escape";
#
#   # Enable CUPS to print documents.
#   # services.printing.enable = true;
#
#   # Enable sound.
#   # services.pulseaudio.enable = true;
#   # OR
#  services.pipewire = {
#    enable = true;
#    pulse.enable = true;
#  };
#
#   # Enable touchpad support (enabled default in most desktopManager).
#   # services.libinput.enable = true;
#
#   # Define a user account. Don't forget to set a password with ‘passwd’.
#  users.users.musa = {
#    isNormalUser = true;
#    extraGroups = [ "wheel" "networkmanager" "surface-control" "video" "input"]; # Enable ‘sudo’ for the user.
#    packages = with pkgs; [
#      tree
#     ];
#   };
#   programs.hyprland = {
#    enable = true;
#     # Use the package from the flake
#    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
#    # Remove the manual portalPackage line here to let the module handle it
#   };
#
#
#
#
# programs.firefox.enable = true;
#
#  #services.hyprland.enable = true;
#   # List packages installed in system profile.
#   # You can use https://search.nixos.org/ to find more packages (and options).
#  environment.systemPackages = with pkgs; [
#    neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
#    wget
#    kitty
#    wofi
#    fastfetch
#    btop
#    git
#    surface-control
#    wl-clipboard
#    libinput
#    linux-firmware
#    discord
#    hyprpaper
#    hyprcursor
#    plymouth
#    mesa
#    libdrm
#    libva
#    libvdpau
#    #qt6ct
#    #xdg-desktop-portal-hyprland
#    #xdg-desktop-portal-gtk
#  ];
#
#
#   # Some programs need SUID wrappers, can be configured further or are
#   # started in user sessions.
#   # programs.mtr.enable = true;
#   # programs.gnupg.agent = {
#   #   enable = true;
#   #   enableSSHSupport = true;
#   # };
#
#   # List services that you want to enable:
#
#   # Enable the OpenSSH daemon.
#  services.openssh.enable = true;
#
#   # Open ports in the firewall.
#   # networking.firewall.allowedTCPPorts = [ ... ];
#   # networking.firewall.allowedUDPPorts = [ ... ];
#   # Or disable the firewall altogether.
#   # networking.firewall.enable = false;
#
#   # Copy the NixOS configuration file and link it from the resulting system
#   # (/run/current-system/configuration.nix). This is useful in case you
#   # accidentally delete configuration.nix.
#   # system.copySystemConfiguration = true;
#
#   # This option defines the first version of NixOS you have installed on this particular machine,
#   # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
#   #
#   # Most users should NEVER change this value after the initial install, for any reason,
#   # even if you've upgraded your system to a new NixOS release.
#   #
#   # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
#   # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
#   # to actually do that.
#   #
#   # This value being lower than the current NixOS release does NOT mean your system is
#   # out of date, out of support, or vulnerable.
#   #
#   # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
#   # and migrated your data accordingly.
#   #
#   # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
#   system.stateVersion = "25.11"; # Did you read the comment?
#
# }
#

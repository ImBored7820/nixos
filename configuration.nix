{ config, lib, pkgs, inputs, stable, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
      #./cachix.nix
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

  # --- Laptop Protection ---
  services.thermald.enable = true;

  # --- GRAPHICS ---
  hardware.graphics = {
   enable = true;
   enable32Bit = true;
   #package = mesa;
   extraPackages = with pkgs; [
    intel-media-driver # Better for modern Intel GPUs (Iris Plus)
    libvdpau-va-gl
    libva-vdpau-driver
    ];
  };
  
  # --- HYPRLAND ---
  xdg.portal.enable = true;
  programs.hyprland = {
   enable = true;
   };
  security.polkit.enable = true;
  services.dbus.enable = true;
  
  
  # --- GNOME ---

  # services.xserver.enable = true;
  # services.xserver.displayManager.gdm.enable = true;
  # services.xserver.desktopManager.gnome.enable = true;

  
  # --- ENVIRONMENT ---
  environment.sessionVariables = {
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
    kitty
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
    hyprlauncher
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
  services.openssh.enable = true;
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";
  system.stateVersion = "25.11"; 
}

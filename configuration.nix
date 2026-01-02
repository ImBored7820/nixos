{ config, lib, pkgs, inputs, stable, hyprland, ... }:

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
   package = hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
   portalPackage = hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
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
    nautilus
    # Linux-Surface
    surface-control
    linux-firmware
    # Main Apps
    discord
    spotify
    # Hypr-Ecosystem + Prereqs.
    waybar
    xdg-desktop-portal
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
    #Ctls
    brightnessctl
    playerctl
    sbctl
    # Misc
    plymouth
    cachix
    home-manager
    ];
  
  # --- SYSTEM ---
  environment.variables.EDITOR = "neovim";
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
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

  # --- Automatic Sbctl Signing ---
  system.activationScripts.signEfi = {
  # deps are for other script names, not packages. 'binsh' is a safe default.
  deps = [ "binsh" ];

  text = ''
    set -euo pipefail

    SBCTL="${pkgs.sbctl}/bin/sbctl"
    EFI_DIR="/boot/EFI"

    # 1. Safety check for sbctl and keys
    if ! [ -x "$SBCTL" ]; then
      echo "sbctl not found — skipping"
      exit 0
    fi

    # 2. Sign NixOS Generations
    if [ -d "$EFI_DIR/nixos" ]; then
      echo "Signing NixOS EFI binaries..."
      find "$EFI_DIR/nixos" -type f -iname '*.efi' -print0 | while IFS= read -r -d "" file; do
        # Only sign if not already signed to save time/wear
        if ! "$SBCTL" verify "$file" >/dev/null 2>&1; then
          echo "Signing: $file"
          "$SBCTL" sign -s "$file"
        fi
      done
    fi

    # 3. Sign Bootloader
    for f in "$EFI_DIR/BOOT/BOOTX64.EFI" "$EFI_DIR/systemd/systemd-bootx64.efi"; do
      if [ -f "$f" ] && ! "$SBCTL" verify "$f" >/dev/null 2>&1; then
        echo "Signing bootloader: $f"
        "$SBCTL" sign -s "$f"
      fi
    done
  '';
};


}

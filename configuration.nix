{ config, lib, pkgs, inputs, stable, hyprland, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
    ];

  # --- BOOT & KERNEL ---
  boot.loader.systemd-boot.enable = true;
  boot.initrd.systemd.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.kernelModules = [ "i915" ]; # Keep this for Intel Graphics
  # Plymouth
  boot.plymouth.enable = true;
  boot.plymouth.theme = "bgrt";
  boot.kernelParams = [ 
  "i915.enable_guc=3" 
  "i915.enable_fbc=1"
  "quiet"
  "splash"
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

  # --- SDDM ---
  services.displayManger.sddm = {
    enable = true;
    wayland.enable = true;
  }

  # --- ENVIRONMENT ---
  environment.sessionVariables = {
   NIXOS_OZONE_WL = "1"; # Forces apps like VSCode/Discord to use Wayland
   NIX_PROXIES_FOR_OPENGL = "1";
  };

  # --- HOME-MANAGER ---
  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;
  home-manager.backupFileExtension = "backup";

  # --- PACKAGES ---
  users.users.musa = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "input" ];
    shell = bash;
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
    # Utilities 
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
    ];

  # --- FONTS ---
  fonts.packages = with pkgs; [
    noto-fonts
    nerd-fonts.jetbrains-mono

  ];
  
  # --- SYSTEM ---
  environment.variables.EDITOR = "neovim";
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  # networking, timezone, and stateVersion settings
  hardware.enableAllFirmware = true;
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
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

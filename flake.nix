{
  ############################################################
  # NixOS flake: Surface Laptop 3 (Intel) + Hyprland
  ############################################################

  description = "NixOS - Surface Laptop 3 (Intel) - Hyprland";

  nixConfig = {
    # Enable flakes for systems that use this flake
    experimental-features = [ "nix-command" "flakes" ];

    # Binary caches for faster builds
    extra-substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
      "https://linux-surface.cachix.org"
      "https://hyprland.cachix.org"
    ];

    extra-trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=" # Confirmed, nix site
      "linux-surface.cachix.org-1:h4xRj4dujnm9I9aL2V7OmUTiT7oEefGVwiI4UQrESsk=" # Confirmed, self maintained
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" # Confirmed, hyprland site
    ];
  };

  inputs = {
    # Base system channel
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Hardware support
    nixos-hardware.url = "github:8bitbuddhist/nixos-hardware?ref=surface-rust-target-spec-fix";
    #nixos-hardware.url = "github:NixOS/nixos-hardware";

    # Window manager
    hyprland.url = "github:hyprwm/Hyprland/v0.53.0";

    # Home Manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Spotify customization
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixos-hardware, hyprland, home-manager, spicetify-nix, ... }:
  let
    system = "x86_64-linux";

    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };

    # Common special args for all configurations
    specialArgs = {
      inherit hyprland nixpkgs spicetify-nix;
    };
  in
  {
    nixosConfigurations.MusaNixos = nixpkgs.lib.nixosSystem {
      inherit system specialArgs;

      modules = [
        # Global nixpkgs configuration
        { nixpkgs.config.allowUnfree = true; }

        # Main configuration
        ./configuration.nix

        # Hardware support
        nixos-hardware.nixosModules.microsoft-surface-common

        # Home Manager integration
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            extraSpecialArgs = { inherit spicetify-nix; };
            users.musa = import ./home.nix;
          };
        }
      ];
    };
  };
}







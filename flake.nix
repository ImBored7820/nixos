{
  ############################################################
  # NixOS flake: Surface Laptop 3 (Intel) + Hyprland
  ############################################################

  description = "NixOS - Surface Laptop 3 (Intel) - Hyprland";
  
  nixConfig = {
        # flakes enabled for systems that use this flake
        experimental-features = [ "nix-command" "flakes" ];

        # prefer extra-substituters/extra-trusted-public-keys for flakes
        extra-substituters = [
          "https://cache.nixos.org"
          "https://linux-surface.cachix.org"
          "https://hyprland.cachix.org"
          "https://nix-community.cachix.org"
        ];
		# TODO: VERIFY KEYS
        extra-trusted-public-keys = [
          "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
	  "linux-surface.cachix.org-1:h4xRj4dujnm9I9aL2V7OmUTiT7oEefGVwiI4UQrESsk="
	  "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
	  "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        ];
      };

  inputs = {
    # Stable base system 
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.11";

    # Unstable channel 
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Surface hardware helpers
    #nixos-hardware.url = "github:NixOS/nixos-hardware";
    nixos-hardware.url = "github:8bitbuddhist/nixos-hardware?ref=surface-rust-target-spec-fix";

    # Hyprland upstream 
    hyprland.url = "github:hyprwm/Hyprland";

    # Home Manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    
  };
  outputs = { self, nixpkgs, nixpkgs-stable, nixos-hardware, hyprland, home-manager, ... }:
  let
    # Target architecture 
    system = "x86_64-linux";

    # Stable pkgs (used by nixosSystem and default modules)
    pkgs = import nixpkgs {
      inherit system;
      # keep allowUnfree true so configuration-level packages can use nonfree if needed
      config.allowUnfree = true;
    };

    stable = import nixpkgs-stable {
      inherit system;
      config.allowUnfree = true;
    };
  in
  {
    # NixOS system entry. Name it the same as your machine/user convention.
    nixosConfigurations.MusaNixos = nixpkgs.lib.nixosSystem {
      inherit system;

      specialArgs = {
        inherit stable; 
	inherit hyprland;
	inherit nixpkgs;
      };

      modules = [
        # Ensure nixpkgs-wide allowUnfree is visible as a module option too.
        {
          nixpkgs.config.allowUnfree = true;
        }
        ./configuration.nix

        # Surface hardware module
        nixos-hardware.nixosModules.microsoft-surface-common

	# Home Manager
	home-manager.nixosModules.home-manager
	{
	  home-manager.users.musa = import ./home.nix;
	}
      ];

    };

  };
}







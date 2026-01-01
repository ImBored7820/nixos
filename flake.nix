{
  ############################################################
  # NixOS flake: Surface Laptop 3 (Intel) + Hyprland
  ############################################################

  description = "NixOS - Surface Laptop 3 (Intel) - Hyprland";

  inputs = {
    # Stable base system 
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";

    # Unstable channel 
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Surface hardware helpers
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # Hyprland upstream 
    hyprland.url = "github:hyprwm/Hyprland";
  };
  outputs = { self, nixpkgs, nixpkgs-unstable, nixos-hardware, hyprland, ... }:
  let
    # Target architecture 
    system = "x86_64-linux";

    # Stable pkgs (used by nixosSystem and default modules)
    pkgs = import nixpkgs {
      inherit system;
      # keep allowUnfree true so configuration-level packages can use nonfree if needed
      config.allowUnfree = true;
    };

    unstable = import nixpkgs-unstable {
      inherit system;
      config.allowUnfree = true;
    };
  in
  {
    # NixOS system entry. Name it the same as your machine/user convention.
    nixosConfigurations.MusaNixos = nixpkgs.lib.nixosSystem {
      inherit system;

      specialArgs = {
        inherit unstable;
        # If you want, you could also expose `hyprland` or specific inputs here,
        # but keep the surface minimal and explicit.
      };

      modules = [
        # Ensure nixpkgs-wide allowUnfree is visible as a module option too.
        {
          nixpkgs.config.allowUnfree = true;
        }

        # Your main NixOS configuration (should accept `unstable` in its args)
        ./configuration.nix

        # Surface hardware module — kept enabled as you had it.
        nixos-hardware.nixosModules.microsoft-surface-common

      ];
    };
  };
}





# {
#   description = "NixOS - Surface Laptop 3 (Intel) - Hyprland";
#
#   inputs = {
#     # Change 'nixos-24.11' to 'nixos-unstable'
#     nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
#     #nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
#     nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
#     nixos-hardware.url = "github:NixOS/nixos-hardware/master";
#     hyprland.url = "github:hyprwm/Hyprland";
#   };
#
#   outputs = { self, nixpkgs, nixpkgs-unstable, nixos-hardware, hyprland, ... }@inputs: {
#     nixosConfigurations.MusaNixos = nixpkgs.lib.nixosSystem {
#       system = "x86_64-linux";
#       specialArgs = { 
#       	inherit inputs; 
# 	unstable = import inputs.nixpkgs-unstable {
#         config.allowUnfree = true;
#     	};
# 	inherit unstable;
#       }; 
#       modules = [
#         {
#           nixpkgs.config.allowUnfree = true;
#         }
#         ./configuration.nix
#         nixos-hardware.nixosModules.microsoft-surface-common
#       ]; 
#     };
#   };
# }

{
  description = "NixOS - Surface Laptop 3 (Intel) - Hyprland (stable)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    # Use the nixos-hardware repo so the surface module and kernel patches are applied
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs = { self, nixpkgs, nixos-hardware, ... }: {
    nixosConfigurations.MusaNixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      # keep thing simple: import your configuration and the surface hardware module
      modules = [
        ./configuration.nix
        nixos-hardware.nixosModules.microsoft-surface-common
      ];
    };
  };
}


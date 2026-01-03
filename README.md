**NixOS Configuration Files**
- flake.nix
- configuration.nix
- home.nix

This is meant to be for devices that require the linux surface kernel

The version currently used for:

  **Kernel**: 6.15.9 (stable)
  
  **Device**: surface-common



**TODO** 

--- 

🧭 NixOS Repository Improvement Checklist

1. Structure & Modularity

• Split configuration into multiple files (hardware, services, networking, desktop, users).
• Create a consistent directory layout (e.g., hosts/, modules/, home/).
• Move host‑specific overrides into their own subdirectories.
• Keep flake outputs minimal and explicit (only import what each host needs).
• Ensure each file has a clear purpose and name.


---

2. Readability & DRY (Don’t Repeat Yourself)

• Remove duplicated package lists or option blocks.
• Define shared lists (e.g., systemPackages) once and reuse them.
• Use Nix abstractions (mkIf, mkOption, inherit, let) to reduce boilerplate.
• Delete unused or disabled modules/services.
• Add comments explaining non‑obvious settings or custom functions.
• Apply consistent indentation, naming, and formatting.


---

3. Redundancy & Efficiency

• Remove duplicate imports of nixpkgs or modules.
• Pin all inputs in flake.lock (no unpinned master branches).
• Use overlays where appropriate instead of repeating package overrides.
• Add binary caches (especially Hyprland’s Cachix) to speed up builds.
• Centralize feature flags instead of scattering enable = true everywhere.


---

4. Security Best Practices

• Verify networking.firewall.enable = true.
• Ensure no secrets (SSH keys, tokens, passwords) are stored in Nix files.
• Use a secrets manager (sops‑nix, pass, or external files).
• Enable Fail2Ban (services.fail2ban.enable = true) if SSH or exposed services exist.
• Enable Flatpak for sandboxing GUI apps.
• Keep nixpkgs input on a recent stable release.
• Disable unnecessary services (e.g., SSH, CUPS) if not used.
• Harden SSH: permitRootLogin = "no", key‑based auth only.


---

5. Hyprland‑Specific Setup

• Enable Hyprland using the flake input’s package and portal.
• Add Hyprland’s portal to xdg.portal.extraPortals.
• Use Hyprland’s Cachix to avoid recompiling dependencies.
• Ensure correct GPU drivers and Mesa versions.
• Use a Wayland‑compatible login manager (SDDM, Greetd).
• Configure Hyprland via Home Manager (wayland.windowManager.hyprland).
• Use proper list syntax and quoting for keybindings and startup apps.


---

6. Consistency & Documentation

• Apply uniform indentation and naming conventions across all files.
• Add a README explaining the structure and how to add new hosts/modules.
• Add comments to clarify design decisions and module responsibilities.


---


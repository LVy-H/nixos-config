# NixOS Configuration

My personal NixOS configuration using Flakes, Lix, and Stylix.

## Features
- **Window Manager:** Sway (SwayFX)
- **Theming:** Stylix with Catppuccin Mocha
- **Shell:** Zsh / Fish
- **Editor:** Nixvim
- **Bar:** Waybar
- **Launcher:** Rofi (Custom Theme)

## Maintenance
To apply changes:
```bash
sudo nixos-rebuild switch --flake .#nixos
```

# NixLinux

Linux-targeted copy of your original `NixDarwin` setup.

## What changed
- Flake output switched from `darwinConfigurations` to `nixosConfigurations`.
- System target switched to `x86_64-linux`.
- Added NixOS NVIDIA configuration (`services.xserver.videoDrivers = [ "nvidia" ]` and `hardware.nvidia` settings).
- Removed Darwin/Homebrew-only config.
- Home Manager `homeDirectory` switched to `/home/anastasia`.

## Deploy on target machine
1. Replace `hardware-configuration.nix` with the machine-generated one:
   - `sudo nixos-generate-config --show-hardware-config > hardware-configuration.nix`
2. Build/apply:
   - `sudo nixos-rebuild switch --flake .#nixlinux`

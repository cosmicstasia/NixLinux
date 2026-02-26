{ modulesPath, ... }:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  # Replace these with values generated on the target machine using:
  # sudo nixos-generate-config --show-hardware-config > hardware-configuration.nix
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/REPLACE_WITH_REAL_UUID";
    fsType = "ext4";
  };

  swapDevices = [ ];
}

{
  imports = [
    # ../modules/common.nix
    # ./Eowyn/hardware.nix
  ];

  system.stateVersion = "23.11";
  networking.hostName = "Eowyn";

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/root";
      fsType = "ext4";
    };

    "/boot/efi" = {
      device = "/dev/disk/by-label/boot";
      fsType = "vfat";
    };
  };

  swapDevices = [
    {
      device = "/dev/disk/by-label/swap";
    }
  ];
}

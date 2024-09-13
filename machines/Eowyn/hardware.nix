{
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/Eroot";
      fsType = "ext4";
    };

    "/boot/efi" = {
      device = "/dev/disk/by-label/Eboot";
      fsType = "vfat";
    };
  };

  swapDevices = [
    {
      device = "/dev/disk/by-label/Eswap";
    }
  ];

  hardware = {
    enableRedistributableFirmware = true;
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
  };

}

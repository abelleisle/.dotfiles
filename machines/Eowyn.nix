{
  imports = [
    ../modules/common.nix
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

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  # boot.loader = {
  #   efi = {
  #     canTouchEfiVariables = true;
  #     efiSysMountPoint = "/boot/efi"; # ← use the same mount point here.
  #   };
  #   grub = {
  #     efiSupport = true;
  #     #efiInstallAsRemovable = true; # in case canTouchEfiVariables doesn't work for your system
  #     device = "nodev";
  #   };
  # };
}

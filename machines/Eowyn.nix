{ system, config, pkgs, ... }: {
  imports = [
    ../pkgs/common.nix
    # ./Eowyn/disko.nix
  ];

  system.stateVersion = "23.11";

  filesystem."/" = {
    device = "/dev/disk/by-label/root";
    fstype = "ext4";
  };

  filesystem."/boot/efi" = {
    device = "/dev/disk/by-label/boot";
    fstype = "vfat";
  };

  swapdevices = [
    {
      device = "/dev/disk/by-label/swap";
    }
  ];

  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot/efi"; # ← use the same mount point here.
    };
    grub = {
      efiSupport = true;
      #efiInstallAsRemovable = true; # in case canTouchEfiVariables doesn't work for your system
      device = "nodev";
    };
  };
}

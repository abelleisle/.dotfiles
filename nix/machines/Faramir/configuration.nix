{
  imports = [];

  system.stateVersion = "23.11";

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

  services.xserver = {
    enable = true;
    displayManager.sddm = {
      enable = true;
      # wayland.enable = true;
    };
    # defaultSession = "plasma";
    # desktopManager.plasma5.enable = true;
  };

  programs.hyprland.enable = true;
}

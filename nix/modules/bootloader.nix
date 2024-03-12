{ lib
, pkgs
, ...
}: {
  # boot.loader = {
  #   efi = {
  #     # Enable this when you install NixOS on a new machine!
  #     canTouchEfiVariables = true;
  #     efiSysMountPoint = "/boot";
  #   };
  #
  #   grub = lib.mkIf (pkgs.stdenv.isAarch64) {
  #     efiSupport = true;
  #     device = "nodev";
  #   };
  #
  #   systemd-boot.enable = lib.mkDefault (!pkgs.stdenv.isAarch64 && !pkgs.stdenv.hostPlatform.isRiscV);
  # };

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

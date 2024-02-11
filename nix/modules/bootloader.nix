{ lib
, pkgs
, ...
}: {
  boot.loader = {
    efi = {
      # Enable this when you install NixOS on a new machine!
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };

    grub = lib.mkIf (pkgs.stdenv.isAarch64) {
      efiSupport = true;
      device = "nodev";
    };

    # something is buggy with systemd-boot on our EFI machine yasmin
    systemd-boot.enable = lib.mkDefault (!pkgs.stdenv.isAarch64 && !pkgs.stdenv.hostPlatform.isRiscV);
  };
}

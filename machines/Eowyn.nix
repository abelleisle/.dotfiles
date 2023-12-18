{ system, config, pkgs, ... }: {
  imports = [
    ../pkgs/common.nix
    ./Eowyn/disko.nix
  ];

  system.stateVersion = "23.11";

  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot/efi";
    };

    grub = {
      efiSupport = true;
      device = "nodev";
    };
  };
}

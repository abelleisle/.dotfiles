{ config, pkgs, ... }: {
  imports = [
    ../pkgs/common.nix
    ./Eowyn/disko.nix
  ];

  config.disko.rootDisk = "/dev/vda";

  system.stateVersion = "23.11";
}

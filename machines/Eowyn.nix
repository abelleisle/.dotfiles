{ config, pkgs, ... }: {
  imports = [
    ../pkgs/common.nix
  ];

  system.stateVersion = "23.11";
}

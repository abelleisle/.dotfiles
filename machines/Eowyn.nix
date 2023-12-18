{ config, pkgs, ... }: {
  imports = [
    ../pkgs/common.nix
    ./Eowyn/disko.nix
  ];

  stateVersion = "23.11";
}

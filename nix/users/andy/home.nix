{ pkgs, pkgs-unstable, ...}:
let
  isDarwin = pkgs.stdenv.isDarwin;
  isLinux = pkgs.stdenv.isLinux;
in
{
  imports = [
    ../dev/home.nix
  ];

  home = {
    stateVersion = "23.11";
    packages = [];
  };

  programs = {
    librewolf = {
      enable = true;
      package = pkgs-unstable.librewolf;
    };
  };
}

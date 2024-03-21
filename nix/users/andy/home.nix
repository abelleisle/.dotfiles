{ pkgs, ... }:
let
  isDarwin = pkgs.stdenv.isDarwin;
  isLinux = pkgs.stdenv.isLinux;
in
{
  imports = [
    ../dev/home.nix
  ];

  home = {
    username = "andy";
    stateVersion = "23.11";
    homeDirectory = if isDarwin
      then "/Users/andy"
      else "/home/andy";
    packages = [];
  };

  programs = {
    librewolf = {
      enable = true;
    };
  };
}

{ pkgs, config, ... }:
let
  isDarwin = pkgs.stdenv.isDarwin;
  isLinux = pkgs.stdenv.isLinux;

  installDir = config.home.homeDirectory + "/.dots";
in
{
  imports = [
    ../../../dots/home.nix
  ];

  home = {
    username = "abelleisle";
    stateVersion = "23.11";
    homeDirectory = if isDarwin
      then "/Users/abelleisle"
      else "/home/abelleisle";
    packages = [];
  };

  dotfiles.dotDir = installDir;
}

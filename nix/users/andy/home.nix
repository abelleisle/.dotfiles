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

  dotfiles.dotDir = installDir;
}

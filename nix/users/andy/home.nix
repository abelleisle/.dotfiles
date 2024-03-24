{ pkgs, config, ... }:
let
  isDarwin = pkgs.stdenv.isDarwin;
  isLinux = pkgs.stdenv.isLinux;

  installDir = config.home.homeDirectory + "/.dots";
in
{
  imports = [
    ../../../dots/home.nix
    ../../../home/common   # Development stuff
    ../../../home/programs # Standard programs
    ../../../home/wm       # Window manager settings
  ];

  home = {
    username = "andy";
    stateVersion = "23.11";
    homeDirectory = if isDarwin
      then "/Users/andy"
      else "/home/andy";
    packages = [];
  };

  dotfiles.dotDir = installDir;
}

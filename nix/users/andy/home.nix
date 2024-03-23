{ pkgs, config, ... }:
let
  isDarwin = pkgs.stdenv.isDarwin;
  isLinux = pkgs.stdenv.isLinux;

  installDir = config.home.homeDirectory + "/.dots";
in
{
  imports = [
    ../../../dots/home.nix
    ../../../home/common/development.nix
  ] ++ pkgs.lib.optionals (isLinux) ../../../home/common/programs.nix ;

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

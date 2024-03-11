{ config, lib, pkgs, ...}:
let
  isDarwin = pkgs.stdenv.isDarwin;
  isLinux = pkgs.stdenv.isLinux;
in
{
  home.packages = [
    pkgs.ripgrep
  ];

  programs = {
    tmux = {
      enable = true;
    };
  };
}

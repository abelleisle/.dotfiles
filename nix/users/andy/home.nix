{ config, lib, pkgs, ...}:
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
    packages = [
      pkgs.bat
      pkgs.fzf
      pkgs.jq
      pkgs.yq
    ];
  };

  programs = {
    zsh = {
      enable = true;
    };

    direnv = {
      enable = true;
    };
  };
}

{ config, lib, pkgs, pkgs-unstable, ...}:
let
  isDarwin = pkgs.stdenv.isDarwin;
  isLinux = pkgs.stdenv.isLinux;
in
{
  home.packages = [
    pkgs.ripgrep
    pkgs.bat
    pkgs.fzf
    pkgs.jq
    pkgs.yq
    pkgs-unstable.logseq
  ];

  programs = {
    home-manager = {
      enable = true;
    };

    zsh = {
      enable = true;
    };

    direnv = {
      enable = true;
      enableZshIntegration = true;
    };

    tmux = {
      enable = true;
    };

    wezterm = {
      enable = true;
      enableZshIntegration = true;
      package = pkgs-unstable.wezterm;
    };
  };
}

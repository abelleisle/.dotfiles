{ pkgs, ... }:
{
  home.packages = [
    pkgs.ripgrep
    pkgs.bat
    pkgs.fzf
    pkgs.jq
    pkgs.yq
    pkgs.logseq
  
    pkgs.fira-code-nerdfont
  ];

  fonts.fontconfig.enable = true;

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
    };
  };

  imports = [
    ./helix.nix
  ];
}

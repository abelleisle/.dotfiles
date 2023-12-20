{ user, hostname, inputs }: # Inputs for system-specific configs
{ config, pkgs, lib, ... }: # Standard nixos module inputs
{
  home = {
    packages = with pkgs; [
      fzf
      neovim
      ripgrep
      tmux
      stow
      zsh
    ];

    stateVersion = "23.11";
  };

  programs.home-manager.enable = true;
}

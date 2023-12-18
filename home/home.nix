{ config, pkgs, user, ... }:

{
  home = {
    packages = [
      fzf
      neovim
      rg
      tmux
      stow
      zsh
    ];

    stateVersion = "23.11";

    xdg = {
      enable = true;
      configFile = {
        "nvim".source = {
          config.lib.file.mkOutOfStoreSymLink ./nvim/.config/nvim;
        };
      };
    };
  };

  programs.home-manager.enable = true;
}

{ config, pkgs, user, ... }:

{
  config.lib.meta = {
    configPath = "${config.${users.users.${user}}.home}/.dotfiles";
    mkMutableSymlink = path: config.lib.file.mkOutOfStoreSymlink
      (config.lib.meta.configPath + removePrefix (toString inputs.self) (toString path));
  };

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

    file = {
      ".config/nvim/" = {
        source = config.lib.meta.mkMutableSymlink ./nvim/.config/nvim;
      };
    };
  };

  programs.home-manager.enable = true;
}

{ user, inputs, ... }:
{ config, pkgs, lib, ... }:
let
    configPath = "${config.users.user.${user}.home}/.dotfiles";
    mkMutableSymlink = path: config.lib.file.mkOutOfStoreSymlink
      (configPath + lib.string.removePrefix (toString inputs.self) (toString path));
in
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

    file = {
      ".config/nvim/" = {
        source = mkMutableSymlink ./nvim/.config/nvim;
      };
    };
  };

  programs.home-manager.enable = true;
}

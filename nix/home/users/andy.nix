{ config, pkgs, lib, ... }: # Standard nixos module inputs
let
  weztermMod = import ../../../dots/wezterm/wezterm.nix;
in
{
  home = {
    stateVersion = "23.11";
    packages = with pkgs; [
      fzf
      neovim
      ripgrep
      tmux
      stow
      zsh
    ];
  };

  programs = {
    home-manager.enable = true;
    wezterm.enable = true;
  };

  imports = [
    weztermMod
  ];

  # home.activation.copyHomeFiles = let
  #   src = config.home-files;
  #   dest = home.homeDirectory + "/home-files";
  # in lib.hm.dag.entryAfter [ "installPackages" ] ''
  #   rm -rf ${dest}
  #   rsync -ah --copy-links --chmod=D755,F664 --quiet ${src}/ ${dest}
  # '';

}

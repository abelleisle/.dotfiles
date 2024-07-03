{ pkgs, config, lib, ... }:
let
  cfg = config.dotfiles;
  dotsLocation = cfg.dotDir;

  symlink = config.lib.file.mkOutOfStoreSymlink;

  nvimInstall = if dotsLocation != null
    then dotsLocation + "/dots/nvim/"
    else ./nvim;

  tmuxInstall = if dotsLocation != null
    then dotsLocation + "/dots/tmux/"
    else ./tmux;

  zshInstall = if dotsLocation != null
    then dotsLocation + "/dots/zsh/"
    else ./zsh;
in
{
  options = {
    dotfiles = {
      dotDir = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        example = "~/.dots";
        description = ''
          Directory where the dotfiles repo is cloned. MUST BE ABSOLUTE PATH.
        '';
      };
    };
  };

  imports = [
    # Enable helix editor
    ./helix.nix
    # Enable colors for shell
    ../home/colors
  ];

  config = {
    home = {
      packages = [
        # Development packages
        pkgs.ripgrep
        pkgs.bat
        pkgs.fzf
        pkgs.jq
        pkgs.yq

        # Fonts
        pkgs.fira-code-nerdfont

        # Manually configured
        pkgs.zsh
        pkgs.tmux
        (pkgs.neovim.override { vimAlias = true; })
      ];

      file = {
        # ZSH
        ".zshrc".source = symlink (zshInstall + ".zshrc");
        ".profile".source = symlink (zshInstall + ".profile");
        ".zprofile".source = symlink (zshInstall + ".zprofile");
        ".zsh" = {
          source = symlink (zshInstall + ".zsh");
          recursive = true;
        };

        # TMUX
        ".tmux.conf".source = symlink (tmuxInstall + ".tmux.conf");
        ".tmux" = {
          source = symlink (tmuxInstall + ".tmux");
          recursive = true;
        };
      };
    };

    xdg.configFile = {
      # Neovim
      "nvim" = {
          source = symlink nvimInstall;
          recursive = true;
      };
    };


    fonts.fontconfig.enable = true;

    programs = {
      # Let home manager manage itself
      home-manager = {
        enable = true;
      };

      # Don't need zsh integration because it's already configured in zshrc
      direnv = {
       enable = true;
       nix-direnv.enable = true;
      };
    };
  };
}

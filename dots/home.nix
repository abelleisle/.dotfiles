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

  config = {
    home = {
      packages = [
        pkgs.ripgrep
        pkgs.bat
        pkgs.fzf
        pkgs.jq
        pkgs.yq
        pkgs.logseq
      
        # Fonts
        pkgs.fira-code-nerdfont

        # Manually configured
        pkgs.zsh
        pkgs.tmux
        pkgs.direnv # Already configured in .zshrc
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
      home-manager = {
        enable = true;
      };
    };
  };

  imports = [
    ./helix.nix
  ];
}

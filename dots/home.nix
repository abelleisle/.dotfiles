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

  zellijInstall = if dotsLocation != null
    then dotsLocation + "/dots/zellij/"
    else ./zellij;
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
    ./ghostty
    # Enable utilities
    ./btop
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
        pkgs.fd
        pkgs.devenv

        # Fonts
        # pkgs.fira-code-nerdfont

        # Manually configured
        pkgs.zellij
        pkgs.zsh
        pkgs.tmux
        (pkgs.neovim.override { vimAlias = true; })

        # Utilities for stuff
        pkgs.bc # Needed for shell
        pkgs.tree-sitter # Neovim tree-sitter binary
        pkgs.wl-clipboard # Neovim clipboard integration

        # Language Servers
        pkgs.lua-language-server
        pkgs.nil
        pkgs.ltex-ls
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

        # Common
        ".shelf/.nixmanaged".text = ''
            This file indicates that this system is managed by nix
        '';
      };
    };

    xdg.configFile = {
      # Neovim
      "nvim" = {
        source = symlink nvimInstall;
        recursive = true;
      };
      "zellij" = {
        source = symlink zellijInstall;
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

      # Enable zsh so we source the correct nix env vars
      # zsh = {
      #   enable = true;
      #   enableCompletion = true;
      #   oh-my-zsh = {
      #     enable = false;
      #     theme = "passion";
      #     custom = "~/.zsh/custom";
      #   };
      # };

      git = {
        enable = true;
        userName = "abelleisle";
        # Allow this to get overridden per-system if required
        userEmail = lib.mkDefault "abelleisle@protonmail.com";
      };
    };
  };
}

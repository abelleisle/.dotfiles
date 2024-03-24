{ lib, pkgs, config, ...}:
let
  nixGL = import ../../../nix/modules/nixGL.nix { inherit pkgs config; };
in
{
  imports = [];

  colors.theme = "gruvbox_dark_hard";

  home.file = {
    ".shelf/nvim.lua".text = ''
      local M = {}

      M.setup = function()
          -------------------
          --  THEME STUFF  --
          -------------------

          require("colors.gruvbox").config()

          ------------------------
          --  VIM CONFIG STUFF  --
          ------------------------

          vim.opt.wrap = false
      end

      return M
    '';
  };

  dotfiles.wm.hyprland = {
    enable = false;
    config = ''
      monitor=,preferred,auto,1
    '';
  };

  dotfiles.programs.personal.enable = false;

  nixGLPrefix = "${pkgs.nix.nixGLIntel}/bin/nixGLIntel";

  # Enable wezterm and configure it
  programs.wezterm = {
    package = (nixGL pkgs.wezterm);
  };


}

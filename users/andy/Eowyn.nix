{ lib, pkgs, config, ...}:
let
  nixGL = import ../../nix/nixGL.nix { inherit pkgs config; };
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
  dotfiles.keyboard.enable = true;

  # Override libGL since this is not a nixOS system
  # nixGLPrefix = "${pkgs.nixgl.nixGLIntel}/bin/nixGLIntel";
  # programs.wezterm.package = (nixGL pkgs.wezterm);
}

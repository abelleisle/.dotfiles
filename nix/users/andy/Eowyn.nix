{ lib, ...}:
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
    enable = true;
    config = ''
      monitor=,preferred,auto,1
    '';
  };

  dotfiles.programs = {
    email.enable = true;
    browser.enable = true;
  };

}

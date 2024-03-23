{ config, ...}:
let
  cfg = config.dotfiles;
in
{
  imports = [];

  colors.theme = "gruvbox_dark_hard";

  home.file = {
    ".shelf/nvim.lua".text = ''
      local M = {}

      M.setup = function()
          require("colors.gruvbox").config()
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

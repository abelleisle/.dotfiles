{ lib, ...}:
{
  imports = [
    ../../../home/common/wm/hyprland.nix
  ];

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

  hyprland.machineConfig = ''
    monitor=,preferred,auto,1
  '';

}

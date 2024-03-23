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
          require("colors.gruvbox").config()
      end

      return M
    '';
  };

  hyprland.machineConfig = ''
    monitor=,preferred,auto,1
  '';

}

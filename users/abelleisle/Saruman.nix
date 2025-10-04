{ ... }:
{
  imports = [
    ../../../home/colors
    ../../../home/common/wezterm
    ../../../dots/helix.nix
  ];

  colors.theme = "onedark_cool";

  home.file = {
    ".shelf/nvim.lua".text = ''
      local g = vim.g
      local o = vim.o

      local G = {}

      G.setup = function()
          o.textwidth   = 100
          o.colorcolumn = "101"
          o.wrap        = false

          require("colors.onedark").config("cool")

          -- If using neovide
          if g.neovide then
              vim.opt.guifont = "FiraCode Nerd Font Mono:h11"
              g.neovide_remember_window_size = true
              g.neovide_remember_window_position = true
              g.neovide_cursor_antialiasing = true
              g.neovide_cursor_vfx_mode = "ripple"
          end
      end

      return G
    '';
  };
}

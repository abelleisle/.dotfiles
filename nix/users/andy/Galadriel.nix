{ config, pkgs, ...}:
let
  cfg = config.dotfiles;
  nixGL = import ../../../nix/modules/nixGL.nix { inherit pkgs config; };
  system = pkgs.system;
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

  nixGLPrefix = "${pkgs.nixgl.nixGLIntel}/bin/nixGLIntel";

  # Enable wezterm and configure it
  programs.wezterm = {
    package = (nixGL pkgs.wezterm);
  };
}

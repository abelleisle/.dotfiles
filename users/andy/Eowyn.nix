{ lib, pkgs, config, ...}:
let
  nixGL = import ../../nix/nixGL.nix { inherit pkgs config; };
in
{
  imports = [];

  colors.theme = "catppuccin_frappe";

  home.file = {
    ".shelf/nvim.lua".text = ''
      local M = {}

      M.setup = function()
          -------------------
          --  THEME STUFF  --
          -------------------

          require("colors.catppuccin").config("frappe")

          ------------------------
          --  VIM CONFIG STUFF  --
          ------------------------

          vim.opt.wrap = false
          vim.g.nix = true
      end

      return M
    '';
  };

  home.packages = with pkgs; [
    speedcrunch
    prismlauncher
    (catppuccin-kde.override {
      accents = [ "blue" ];
      flavour = [ "frappe" ];
      winDecStyles = [ "modern" "classic" ];
    })
    gimp
  ];

  dotfiles.wm.hyprland = {
    enable = false;
    config = ''
      monitor=,preferred,auto,1
    '';
  };

  dotfiles.programs = {
    personal.enable = true;
    email.enable = true;
    browser.enable = true;
  };
  dotfiles.keyboard.enable = true;

  # Override libGL since this is not a nixOS system
  # nixGLPrefix = "${pkgs.nixgl.nixGLIntel}/bin/nixGLIntel";
  # programs.wezterm.package = (nixGL pkgs.wezterm);

  catppuccin = {
    enable = true;
    flavor = "frappe";
  };

  gtk = {
    enable = true;
    catppuccin = {
      enable = true;
      flavor = "frappe";
      icon = {
        enable = true;
      };
    };
  };

  qt = {
    enable = true;
    style = {
      name = "kvantum";
      catppuccin = {
        enable = true;
        flavor = "frappe";
        apply = true;
      };
    };
    platformTheme = {
      name = "kvantum";
    };
  };

  home.pointerCursor = {
    gtk.enable = true;
    name = "Catppuccin-Frappe-Blue-Cursors";
    package = pkgs.catppuccin-cursors.frappeBlue;
    size = 24;
  };
}

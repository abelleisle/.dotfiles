{ config, lib, pkgs, ... }:
let
  palette = config.colors.palette;
in
{
  # Wezterm requires colors
  imports = [
    ../../home/colors
  ];

  home.packages = with pkgs; [
    ghostty
  ];

  xdg.configFile = with lib.strings; {
    "ghostty/config".text = ''
      # background  = ${palette.special.background}
      # foreground  = ${palette.special.foreground}

      # palette = 0=${palette.colors.color0}
      # palette = 1=${palette.colors.color1}
      # palette = 2=${palette.colors.color2}
      # palette = 3=${palette.colors.color3}
      # palette = 4=${palette.colors.color4}
      # palette = 5=${palette.colors.color5}
      # palette = 6=${palette.colors.color6}
      # palette = 7=${palette.colors.color7}
      # palette = 8=${palette.colors.color8}
      # palette = 9=${palette.colors.color9}
      # palette = 10=${palette.colors.color10}
      # palette = 11=${palette.colors.color11}
      # palette = 12=${palette.colors.color12}
      # palette = 13=${palette.colors.color13}
      # palette = 14=${palette.colors.color14}
      # palette = 15=${palette.colors.color15}

      keybind = alt+one=unbind
      keybind = alt+two=unbind
      keybind = alt+three=unbind
      keybind = alt+four=unbind
      keybind = alt+five=unbind
      keybind = alt+six=unbind
      keybind = alt+seven=unbind
      keybind = alt+eight=unbind
      keybind = alt+nine=unbind

      # theme = dark:catppuccin-frappe,light:catppuccin-latte
      # theme = dark:matcha-dark-aliz,light:matcha-light-aliz
      theme = dark:"Adwaita Dark",light:Adwaita
    '';

    "ghostty/themes/matcha-dark-aliz" = let 
      c = import ../../home/colors/themes/matcha_aliz_dark.nix;
      
    in {
      text = ''
        background  = ${c.special.background}
        foreground  = ${c.special.foreground}
        cursor-color = ${c.special.cursor}
        cursor-text = ${c.special.foreground}
        selection-foreground = ${c.special.foreground}
        selection-background = ${c.colors.color8}


        palette = 0=${c.colors.color0}
        palette = 1=${c.colors.color1}
        palette = 2=${c.colors.color2}
        palette = 3=${c.colors.color3}
        palette = 4=${c.colors.color4}
        palette = 5=${c.colors.color5}
        palette = 6=${c.colors.color6}
        palette = 7=${c.colors.color7}
        palette = 8=${c.colors.color8}
        palette = 9=${c.colors.color9}
        palette = 10=${c.colors.color10}
        palette = 11=${c.colors.color11}
        palette = 12=${c.colors.color12}
        palette = 13=${c.colors.color13}
        palette = 14=${c.colors.color14}
        palette = 15=${c.colors.color15}
      '';
    };


    "ghostty/themes/matcha-light-aliz" = let 
      c = import ../../home/colors/themes/matcha_aliz_light.nix;
      
    in {
      text = ''
        background  = ${c.special.background}
        foreground  = ${c.special.foreground}
        cursor-color = ${c.special.cursor}
        cursor-text = ${c.special.foreground}
        selection-foreground = ${c.special.foreground}
        selection-background = ${c.colors.color8}


        palette = 0=${c.colors.color0}
        palette = 1=${c.colors.color1}
        palette = 2=${c.colors.color2}
        palette = 3=${c.colors.color3}
        palette = 4=${c.colors.color4}
        palette = 5=${c.colors.color5}
        palette = 6=${c.colors.color6}
        palette = 7=${c.colors.color7}
        palette = 8=${c.colors.color8}
        palette = 9=${c.colors.color9}
        palette = 10=${c.colors.color10}
        palette = 11=${c.colors.color11}
        palette = 12=${c.colors.color12}
        palette = 13=${c.colors.color13}
        palette = 14=${c.colors.color14}
        palette = 15=${c.colors.color15}
      '';
    };
  };
}

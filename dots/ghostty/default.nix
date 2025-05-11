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
      background  = ${palette.special.background}
      foreground  = ${palette.special.foreground}

      palette = 0=${palette.colors.color0}
      palette = 1=${palette.colors.color1}
      palette = 2=${palette.colors.color2}
      palette = 3=${palette.colors.color3}
      palette = 4=${palette.colors.color4}
      palette = 5=${palette.colors.color5}
      palette = 6=${palette.colors.color6}
      palette = 7=${palette.colors.color7}
      palette = 8=${palette.colors.color8}
      palette = 9=${palette.colors.color9}
      palette = 10=${palette.colors.color10}
      palette = 11=${palette.colors.color11}
      palette = 12=${palette.colors.color12}
      palette = 13=${palette.colors.color13}
      palette = 14=${palette.colors.color14}
      palette = 15=${palette.colors.color15}

      keybind = alt+one=unbind
      keybind = alt+two=unbind
      keybind = alt+three=unbind
      keybind = alt+four=unbind
      keybind = alt+five=unbind
      keybind = alt+six=unbind
      keybind = alt+seven=unbind
      keybind = alt+eight=unbind
      keybind = alt+nine=unbind
    '';
  };
}

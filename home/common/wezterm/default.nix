{ pkgs, config, lib, ... }:
let
  palette = config.colors.palette;
in
{
  # Wezterm requires colors
  imports = [
    ../../colors
  ];

  # Enable wezterm and configure it
  programs.wezterm = {
    enable = true;
    extraConfig =
      builtins.elemAt (
        lib.strings.splitString
          "--NIXSPLIT" # Remove the first wezterm import
          (lib.strings.fileContents ./wezterm.lua)
        )
        1; # Access the file AFTER the split
  };

  home.file = {
    # Colors
    ".shelf/wezterm.toml".text = ''
      [colors]
      ansi = [
          '${palette.colors.color0}',
          '${palette.colors.color1}',
          '${palette.colors.color2}',
          '${palette.colors.color3}',
          '${palette.colors.color4}',
          '${palette.colors.color5}',
          '${palette.colors.color6}',
          '${palette.colors.color7}'
      ]
      brights = [
          '${palette.colors.color8}',
          '${palette.colors.color9}',
          '${palette.colors.color10}',
          '${palette.colors.color11}',
          '${palette.colors.color12}',
          '${palette.colors.color13}',
          '${palette.colors.color14}',
          '${palette.colors.color15}'
      ]

      # Special
      cursor_bg     = '${palette.special.foreground}'
      cursor_fg     = '${palette.special.foreground}'
      cursor_border = '${palette.special.foreground}'
      background    = '${palette.special.background}'
      foreground    = '${palette.special.foreground}'
      selection_bg  = '${palette.colors.color7}'
      selection_fg  = '${palette.colors.color0}'

      [colors.indexed]

      [metadata]
      name = 'Nix generated colors'
    '';
  };
}

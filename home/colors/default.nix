{ pkgs, lib, config, ... }:
let
  cfg = config.colors;

  cp = cfg.palette;

  defaultPalette = {
    special = {
      background = "#1d2021";
      foreground = "#d5c4a1";
      cursor = "#d5c4a1";
    };
    colors = {
      color0 = "#1d2021";
      color1 = "#fb4934";
      color2 = "#b8bb26";
      color3 = "#fabd2f";
      color4 = "#83a598";
      color5 = "#d3869b";
      color6 = "#8ec07c";
      color7 = "#d5c4a1";

      color8 = "#665c54";
      color9 = "#cc241d";
      color10 = "#98971a";
      color11 = "#d79921";
      color12 = "#458588";
      color13 = "#b16286";
      color14 = "#689d6a";
      color15 = "#fbf1c7";
    };
  };
in
{
  options = {
    colors = {
      theme = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = "gruvbox_dark_hard";
        example = "gruvbox";
        description = ''
          Which colorscheme to use?
        '';
      };

      palette = lib.mkOption {
        type = lib.types.attrs;
      };
    };
  };

  config = {
    home.file = {
      # http://pod.tst.eu/http://cvs.schmorp.de/rxvt-unicode/doc/rxvt.7.pod#XTerm_Operating_System_Commands
      # 10 = text foreground
      # 11 = text background
      # 12 = cursor foreground
      # 13 = mouse foreground
      # 17 = highlight background
      # 19 = highlight foreground
      # 708 = background border
      ".shelf/sequences".text = lib.strings.concatStrings [
        "]4;0;${cp.colors.color0}\\"
        "]4;1;${cp.colors.color1}\\"
        "]4;2;${cp.colors.color2}\\"
        "]4;3;${cp.colors.color3}\\"
        "]4;4;${cp.colors.color4}\\"
        "]4;5;${cp.colors.color5}\\"
        "]4;6;${cp.colors.color6}\\"
        "]4;7;${cp.colors.color7}\\"
        "]4;8;${cp.colors.color8}\\"
        "]4;9;${cp.colors.color9}\\"
        "]4;10;${cp.colors.color10}\\"
        "]4;11;${cp.colors.color11}\\"
        "]4;12;${cp.colors.color12}\\"
        "]4;13;${cp.colors.color13}\\"
        "]4;14;${cp.colors.color14}\\"
        "]4;15;${cp.colors.color15}\\"
        "]10;${cp.special.foreground}\\"
        "]11;${cp.special.background}\\"
        "]12;${cp.special.foreground}\\"
        "]13;${cp.special.foreground}\\"
        "]17;${cp.special.foreground}\\"
        "]19;${cp.special.background}\\"
        "]4;232;${cp.colors.color0}\\"
        "]4;256;${cp.colors.color7}\\"
        "]708;${cp.special.background}\\"
      ];

      ".shelf/colors-tty.sh".text = with lib.strings; ''
        #!/bin/sh
        [ "''${TERM:-none}" = "linux" ] && \
            printf '%b' '\e]P0${removePrefix "#" cp.colors.color0}
                         \e]P1${removePrefix "#" cp.colors.color1}
                         \e]P2${removePrefix "#" cp.colors.color2}
                         \e]P3${removePrefix "#" cp.colors.color3}
                         \e]P4${removePrefix "#" cp.colors.color4}
                         \e]P5${removePrefix "#" cp.colors.color5}
                         \e]P6${removePrefix "#" cp.colors.color6}
                         \e]P7${removePrefix "#" cp.colors.color7}
                         \e]P8${removePrefix "#" cp.colors.color8}
                         \e]P9${removePrefix "#" cp.colors.color9}
                         \e]PA${removePrefix "#" cp.colors.color10}
                         \e]PB${removePrefix "#" cp.colors.color11}
                         \e]PC${removePrefix "#" cp.colors.color12}
                         \e]PD${removePrefix "#" cp.colors.color13}
                         \e]PE${removePrefix "#" cp.colors.color14}
                         \e]PF${removePrefix "#" cp.colors.color15}
                         \ec'
      '';
    };

    colors.palette = if (cfg.theme != null)
      then import ./themes/${cfg.theme}.nix
      else defaultPalette;
  };
}

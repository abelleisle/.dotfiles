{ lib, config, ... }:
let
  cfg = config.dotfiles.wm.hyprland;
  cp = config.colors.palette;
in
with lib; {
  options = {
    dotfiles.wm.hyprland = {
      enable = mkOption {
        type = types.bool;
        description = "Enable hyprland?";
      };
      config = mkOption {
        type = types.str;
        default = "";
      };
    };
  };

  imports = [
    ../colors
  ];

  config = mkIf (cfg.enable) {
    warnings =
      lib.optional (cfg.config == "")
        ("Please add a machine-specific hyprland configuration with "
         + "`dotfiles.wm.hyprland.config`");

    # Fuzzel
    # dmenu picker
    programs.fuzzel = {
      enable = true;
      settings = {
        main = {
          font = "FiraCode Nerd Font";
        };
        colors = {
          background = "${cp.special.background}dd";
          text = "${cp.special.foreground}ff";
          match = "${cp.colors.color1}ff";
          selection = "${cp.colors.color8}dd";
          selection-text = "${cp.special.foreground}ff";
          border = "${cp.colors.color4}ff";
        };
        border = {
          width = 2;
          radius = 10;
        };
        dmenu = {};
        key-bindings = {};
      };
    };

    # Hyprland
    # Window manager
    wayland.windowManager.hyprland = {
      enable = true;
      xwayland.enable = true;
      systemd = {
        enable = true;
      };
      extraConfig = ''
        # Load colors
        source = ~/.shelf/hypr.conf

        # Some default env vars.
        env = XCURSOR_SIZE,24
        env = XDG_SESSION_TYPE,wayland
        env = XDG_SESSION_DESKTOP,Hyprland
        env = XDG_CURRENT_DESKTOP,Hyprland
        env = _JAVA_AWT_WM_NONREPARENTING,1

        ${cfg.config}

        # Set our mod key to SUPER
        $mainMod = SUPER

        # Generic program launchers
        bind = $mainMod, space, exec, pkill fuzzel || fuzzel
        bind = $mainMod, return, exec, wezterm-gui

        # Window control
        bind = $mainMod, Q, killactive,
        bind = $mainMod_SHIFT, E, exit,
        bind = $mainMod, S, togglefloating,
        bind = $mainMod, G, togglegroup,
        bind = $mainMod_SHIFT, G, moveoutofgroup
        bind = $mainMod, P, pseudo, # dwindle
        bind = $mainMod, J, togglesplit, # dwindle
        bind = $mainMod, F, fullscreen, 0
        bind = $mainMod, M, fullscreen, 1
        bind = $mainMod, A, swapnext

        # Move focus with mainMod + arrow keys
        bind = $mainMod, left, movefocus, l
        bind = $mainMod, right, movefocus, r
        bind = $mainMod, up, movefocus, u
        bind = $mainMod, down, movefocus, d

        # Move windows
        # bind = $mainMod_SHIFT, right, movewindoworgroup, r
        # bind = $mainMod_SHIFT, left, movewindoworgroup, l
        # bind = $mainMod_SHIFT, up, movewindoworgroup, u
        # bind = $mainMod_SHIFT, down, movewindoworgroup, d

        # Switch workspaces with mainMod + [0-9]
        bind = $mainMod, 1, workspace, 1
        bind = $mainMod, 2, workspace, 2
        bind = $mainMod, 3, workspace, 3
        bind = $mainMod, 4, workspace, 4
        bind = $mainMod, 5, workspace, 5
        bind = $mainMod, 6, workspace, 6
        bind = $mainMod, 7, workspace, 7
        bind = $mainMod, 8, workspace, 8
        bind = $mainMod, 9, workspace, 9
        bind = $mainMod, 0, workspace, 10

        # Move active window to a workspace with mainMod + SHIFT + [0-9]
        bind = $mainMod SHIFT, 1, movetoworkspace, 1
        bind = $mainMod SHIFT, 2, movetoworkspace, 2
        bind = $mainMod SHIFT, 3, movetoworkspace, 3
        bind = $mainMod SHIFT, 4, movetoworkspace, 4
        bind = $mainMod SHIFT, 5, movetoworkspace, 5
        bind = $mainMod SHIFT, 6, movetoworkspace, 6
        bind = $mainMod SHIFT, 7, movetoworkspace, 7
        bind = $mainMod SHIFT, 8, movetoworkspace, 8
        bind = $mainMod SHIFT, 9, movetoworkspace, 9
        bind = $mainMod SHIFT, 0, movetoworkspace, 10
      '';
    };

    home.file = {
      ".shelf/hypr.conf".text = with lib.strings; ''
        $color_0 =  rgb(${removePrefix "#" cp.colors.color0})
        $color_1 =  rgb(${removePrefix "#" cp.colors.color1})
        $color_2 =  rgb(${removePrefix "#" cp.colors.color2})
        $color_3 =  rgb(${removePrefix "#" cp.colors.color3})
        $color_4 =  rgb(${removePrefix "#" cp.colors.color4})
        $color_5 =  rgb(${removePrefix "#" cp.colors.color5})
        $color_6 =  rgb(${removePrefix "#" cp.colors.color6})
        $color_7 =  rgb(${removePrefix "#" cp.colors.color7})
        $color_8 =  rgb(${removePrefix "#" cp.colors.color8})
        $color_9 =  rgb(${removePrefix "#" cp.colors.color9})
        $color_10 = rgb(${removePrefix "#" cp.colors.color10})
        $color_11 = rgb(${removePrefix "#" cp.colors.color11})
        $color_12 = rgb(${removePrefix "#" cp.colors.color12})
        $color_13 = rgb(${removePrefix "#" cp.colors.color13})
        $color_14 = rgb(${removePrefix "#" cp.colors.color14})
        $color_15 = rgb(${removePrefix "#" cp.colors.color15})

        $color_bg = rgb(${removePrefix "#" cp.special.background})
        $color_fg = rgb(${removePrefix "#" cp.special.foreground})
      '';
    };
  };

}

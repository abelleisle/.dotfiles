{ lib, config, ... }:
let
  cfg = config.hyprland;
in
{
  options = {
    hyprland.machineConfig = lib.mkOption {
      type = lib.types.str;
    };
  };

  config = {
    programs.fuzzel = {
      enable = true;
    };

    wayland.windowManager.hyprland = {
      enable = true;
      xwayland.enable = true;
      systemd = {
        enable = true;
      };
      extraConfig = cfg.machineConfig + ''
        # See https://wiki.hyprland.org/Configuring/Keywords/ for more
        $mainMod = SUPER

        # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
        bind = $mainMod, return, exec, wezterm-gui
        bind = $mainMod, Q, killactive,
        bind = $mainMod_SHIFT, E, exit,
        bind = $mainMod, S, togglefloating,
        bind = $mainMod, G, togglegroup,
        bind = $mainMod_SHIFT, G, moveoutofgroup
        bind = $mainMod, space, exec, pkill fuzzel || fuzzel
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
  };

}

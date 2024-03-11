{ config, lib, pkgs, ...}:
{
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    extraConfig = lib.readFile ../../../dots/hyprland/.config/hypr/hyprland.conf;
  };

}

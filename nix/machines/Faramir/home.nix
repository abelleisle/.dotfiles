{ config, lib, pkgs, ...}:
{
  programs.hyprland.enable = true;

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    extraConfig = lib.readFile ../../../dots/hyprland/.config/hypr/hyprland.conf;
  };

}

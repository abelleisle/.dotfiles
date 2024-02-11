{ config, lib, pkgs, ... }:
{
  config.programs.wezterm = {
    extraConfig = lib.readFile ./.wezterm.lua;
  };
}

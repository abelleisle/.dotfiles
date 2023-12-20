{
  user,
  hostname,
  inputs,
}: # Inputs for system-specific configs
{ config, lib, pkgs, ... }:
{
  config.programs.wezterm = {
    extraConfig = lib.readFile ./.wezterm.lua;
  };
}

{ inputs, pkgs, lib, isVM, ... }:
{
  imports = [
    ./common.nix
  ];

  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
  };

  environment.sessionVariables = lib.mkIf (isVM) {
    WLR_RENDERER_ALLOW_SOFTWARE = "1";
  };
}

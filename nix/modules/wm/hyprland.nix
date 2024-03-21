{ inputs, pkgs, lib, isVM, ... }:
{
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
  };

  environment.sessionVariables = lib.mkIf (isVM) {
    WLR_RENDERER_ALLOW_SOFTWARE = "1";
  };
}

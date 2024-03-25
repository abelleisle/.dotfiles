{ pkgs, lib, config, isVM, ... }:
let
  cfg = config.programs.wm;
in
with lib;
{
  options = {
    programs.wm = {
      hyprland.enable = mkOption {
        type = types.bool;
        description = "Enable hyprland (system)";
      };
    };
  };

  config = {
    programs.hyprland = {
      enable = cfg.hyprland.enable;
    };

    environment.sessionVariables = lib.mkIf (isVM) {
      WLR_RENDERER_ALLOW_SOFTWARE = "1";
    };
  };
}

{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.dotfiles.keyboard;
in
with lib;
{
  options = {
    dotfiles.keyboard = {
      enable = mkOption {
        type = types.bool;
        description = "Enable keyboard configuration software?";
      };
    };
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.vial
      pkgs.uhk-agent
    ];
  };
}

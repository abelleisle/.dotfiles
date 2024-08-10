{ pkgs, lib, config, ... }:
let
  cfg = config.programs.gaming;
in
with lib;
{
  options = {
    programs.gaming = {
      enable = mkOption {
        type = types.bool;
        description = "Enable gaming software";
      };
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      webcord
    ];

    programs = {
      steam = {
        enable = true;
      };
    };

    hardware = {
      steam-hardware = {
        enable = true;
      };
    };
  };
}

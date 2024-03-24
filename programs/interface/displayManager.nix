{ lib, config, ... }:
let
  cfg = config.programs.dm;
in
with lib;
{
  options = {
    programs.dm = mkOption {
      type = types.enum ["sddm"];
      description = "Which display manager to use?";
    };
  };

  config = {
    # Enable SDDM
    services.xserver = {
      enable = true;
      displayManager.sddm = {
        enable = (cfg == "sddm");
      };
    };
  };
}

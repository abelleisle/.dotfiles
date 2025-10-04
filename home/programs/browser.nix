{ lib, config, ... }:
let
  cfg = config.dotfiles.programs;
in
with lib;
{
  options = {
    # Enable browsers
    dotfiles.programs.browser.enable = mkOption {
      type = types.bool;
      description = "Enable browsers";
    };
  };

  config = mkIf (cfg.personal.enable && cfg.browser.enable) {
    programs = {
      # Librewolf
      librewolf = {
        enable = true;
      };
    };
  };
}

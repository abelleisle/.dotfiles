{ lib, ... }:
with lib;
{
  options = {
    dotfiles.programs = {
      # Master option to disable all personal programs
      personal.enable = mkOption {
        type = types.bool;
        default = true;
        description = "Should personal programs be enabled?";
      };
    };
  };

  imports = [
    ./browser.nix
    ./email.nix
  ];
}

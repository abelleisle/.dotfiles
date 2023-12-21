{ user, hostname, inputs }: # Inputs for system-specific configs
{ config, pkgs, lib, ... }: # Standard nixos module inputs
{
  home = {
    packages = with pkgs; [
      wezterm
    ];
  };

  programs = {
    home-manager.enable = true;
  };

  # home.activation.copyHomeFiles = let
  #   src = config.home-files;
  #   dest = home.homeDirectory + "/home-files";
  # in lib.hm.dag.entryAfter [ "installPackages" ] ''
  #   rm -rf ${dest}
  #   rsync -ah --copy-links --chmod=D755,F664 --quiet ${src}/ ${dest}
  # '';

}

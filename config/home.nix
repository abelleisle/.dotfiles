{ user, hostname, inputs }: # Inputs for system-specific configs
{ config, pkgs, lib, ... }: # Standard nixos module inputs
let
  homeFolder = (baseDir:
    let
      makePath = (breadcrumbs: baseDir + "/${lib.strings.concatStringsSep "/" breadcrumbs}");
      fileImport = (breadcrumbs: type: { "${lib.strings.concatStringsSep "/" breadcrumbs}".source = makePath breadcrumbs; });
      iterDir = (breadcrumbs: let
          fileSet = builtins.readDir (makePath breadcrumbs);
          processItem = (location: type: let
              breadcrumbs' = breadcrumbs ++ [location];
            in
              if
                type == "regular"
              then
                [ (fileImport breadcrumbs' type) ]
              else if
                type == "directory"
              then
                iterDir breadcrumbs'
              else
                []
          );
        in
          lib.attrsets.mapAttrsToList processItem fileSet
      );
    in
      lib.attrsets.mergeAttrsList (lib.lists.flatten (iterDir []))
  );
in
{
  home = {
    stateVersion = "23.11";

    packages = with pkgs; [
      fzf
      neovim
      ripgrep
      tmux
      stow
      zsh
    ];

    file = homeFolder ../config;
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

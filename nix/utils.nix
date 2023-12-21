{ inputs
, self
, home-manager
, nixpkgs
, darwin
, sensitive
, pkgs
, system
, stateVersion
}: rec {

  # Window managers used by the system
  wms = {
    bspwm = "x";
    hyprland = "wayland";
    plasma = "wayland";
    sway = "wayland";
  };

  maybeUserConfig = user:
    let personalized_config = ./home/users + "/${user}.nix";
    in
    if builtins.pathExists personalized_config then
      personalized_config
    else
      ./home/users/user.nix;

  # home-manager on nixos
  homeConfig = user: userConfigs: wm:
    { ... }: {
      imports = [ (maybeUserConfig user) ] ++ userConfigs
        ++ (if wms ? "${wm}" then [
        ./home/display/display.nix
        (./home/display + "/${wm}.nix")
      ] else
        [ ]);
    };

  # for raw home-manager configurations
  mkHome = username: {
    "${username}" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [
        # No NixOs
        ./home/standalone.nix

        # Specify the path to your home configuration here
        (import (maybeUserConfig username)
          {
            inherit inputs system pkgs self stateVersion;
          })

        # Set home directory
        {
          # Annoying. Not sure when this started beign required.
          nix.package = pkgs.nix;
          home = {
            inherit stateVersion username;
            homeDirectory = "/home/${username}";
          };
        }
      ];
    };
  };

  # for nixos
  mkComputer =
    { machineConfig
    , user ? sensitive.lib.user
    , wm ? ""
    , extraModules ? [ ]
    , userConfigs ? [ ]
    , isContainer ? false
    , isDarwin ? false
    }: let
      mkSystem = if isDarwin then darwin.lib.darwinSystem else nixpkgs.lib.nixosSystem;
    in mkSystem {
      inherit system pkgs;
      # Arguments to pass to all modules.
      specialArgs = {
        inherit system inputs sensitive user self isContainer stateVersion;
      };
      modules = [
        # System configuration for this host
        machineConfig
        ./common.nix

        # home-manager configuration
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = { inherit inputs self stateVersion; };
          home-manager.users."${user}" =
            homeConfig user userConfigs wm { inherit inputs system pkgs self; };
        }
      ] ++ extraModules ++ (if !isContainer then [
        ./common/fonts.nix
        ./common/getty.nix
        ./common/head.nix
      ] else
        [ ]) ++ (if wms ? "${wm}" then
        [ (./. + ("/display/" + wms."${wm}") + ".nix") ]
      else
        [ ]);
    };
}

{ inputs
, self
, home-manager
, nixpkgs
, darwin
# , sensitive
}: system: rec {

  overlays = [];

  # pkgs = nixpkgs.legacyPackages.${system};
  pkgs = import nixpkgs {
    inherit system overlays;
  };

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
        # ./home/display/display.nix
        # (./home/display + "/${wm}.nix")
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
            inherit inputs system pkgs self ;
          })

        # Set home directory
        {
          # Annoying. Not sure when this started beign required.
          nix.package = pkgs.nix;
          home = {
            inherit username;
            homeDirectory = if darwin then "/Users/${username}" else "/home/${username}";
          };
        }
      ];
    };
  };

  # for nixos
  mkComputer =
    { machineConfig
    , user ? "andy"
    , wm ? ""
    , extraModules ? [ ]
    , userConfigs ? [ ]
    , isContainer ? false
    , isDarwin ? false
    }: let
      mkSystem = if isDarwin then darwin.lib.darwinSystem else nixpkgs.lib.nixosSystem;
      mkHomeMg = if isDarwin then home-manager.darwinModules else home-manager.nixosModules;
      userConfig = if isDarwin then (./users + "/${user}/darwin.nix") else (./users + "/${user}/linux.nix");
    in mkSystem {
      inherit system pkgs;
      # Arguments to pass to all modules.
      specialArgs = {
        inherit system inputs /*sensitive*/ user self isContainer;
      };
      modules = [
        # System configuration for this host
        machineConfig
        # ./common.nix
        ./modules/common.nix

        userConfig

        # home-manager configuration
        mkHomeMg.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = { inherit inputs self; };
          home-manager.users."${user}" =
            homeConfig user userConfigs wm { inherit inputs system pkgs self; };
        }
      ] ++ extraModules ++ (if !isContainer then [
        # ./common/fonts.nix
        # ./common/getty.nix
        # ./common/head.nix
      ] else
        [ ]) ++ (if wms ? "${wm}" then
        [ (./. + ("/display/" + wms."${wm}") + ".nix") ]
      else
        [ ]);
    };
}
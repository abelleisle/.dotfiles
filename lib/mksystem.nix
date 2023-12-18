# This function creates a NixOS system based on our VM setup for a
# particular architecture.
{ nixpkgs, overlays, inputs, disko }:

hostname:
{
  system,
  user,
  darwin ? false,
}:

let
  # The config files for this system.
  machineConfig = ../machines/${hostname}.nix;
  userOSConfig = ../users/${user}/${if darwin then "darwin" else "linux" }.nix;
  userHMConfig = ../home/home.nix;

  # NixOS vs nix-darwin functionst
  systemFunc = if darwin then inputs.darwin.lib.darwinSystem else nixpkgs.lib.nixosSystem;
  home-manager = if darwin then inputs.home-manager.darwinModules else inputs.home-manager.nixosModules;
in systemFunc rec {
  inherit system disko;

  modules = [
    # Apply our overlays. Overlays are keyed by system type so we have
    # to go through and apply our system type. We do this first so
    # the overlays are available globally.
    # { nixpkgs.overlays = overlays; }

    machineConfig
    userOSConfig
    home-manager.home-manager {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.${user} = import userHMConfig {
        inputs = inputs;
        user = user;
      };
    }

    # We expose some extra arguments so that our modules can parameterize
    # better based on these values.
    {
      config._module.args = {
        currentSystem = system;
        currentSystemName = hostname;
        currentSystemUser = user;
        inputs = inputs;
      };
    }
  ];
}

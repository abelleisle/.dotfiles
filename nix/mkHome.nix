# NixOS args
{ self
, overlays
, lib
}:

# Required args
username: system:

# Optional args
{darwin ? false
,
}:
let
  inputs = self.inputs;

  home-manager = inputs.home-manager;

  pkgs = import inputs.nixpkgs {
    inherit system overlays;
  };

  pkgs-stable = import inputs.nixpkgs-stable {
    inherit system overlays;
  };

  extraSpecialArgs = {
    inherit pkgs-stable;
  };

in home-manager.lib.homeManagerConfiguration
{
  inherit pkgs extraSpecialArgs;

  modules = [
    ./users/${username}/home.nix
  ];
}


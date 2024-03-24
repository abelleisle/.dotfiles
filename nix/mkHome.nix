# NixOS args
{ self
, overlays
, lib
}:

# Required args
username: system:

# Optional args
{ darwin ? false
, extraImports ? []
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

    {
      options.nixGLPrefix = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = ''
          Will be prepended to commands which require working OpenGL.

          This needs to be set to the right nixGL package on non-NixOS systems.
        '';
      };
    }

    inputs.agenix.homeManagerModules.default
  ] ++ extraImports;
}


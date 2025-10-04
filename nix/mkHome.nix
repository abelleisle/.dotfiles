# NixOS args
{
  self,
  overlays,
  lib,
  unfree_whitelist,
}:

# Required args
username: system:

# Optional args
{
  extraImports ? [ ],
  allowUnfree ? false,
}:
let
  inherit (self) inputs;

  inherit (inputs) home-manager;

  pkgs = import inputs.nixpkgs {
    inherit system overlays;
    config = {
      inherit allowUnfree;
      allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) unfree_whitelist;
    };
  };

  pkgs-stable = import inputs.nixpkgs-stable {
    inherit system;
    config.allowUnfree = allowUnfree;
  };

  extraSpecialArgs = {
    inherit pkgs-stable;
  };

in
home-manager.lib.homeManagerConfiguration {
  inherit pkgs extraSpecialArgs;

  modules = [
    ../users/${username}/home.nix

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
    inputs.catppuccin.homeModules.catppuccin
    inputs.zen-browser.homeModules.twilight-official
    ../templates/home
  ]
  ++ extraImports;
}

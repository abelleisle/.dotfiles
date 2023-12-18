{
  description = "NixOS workstation configs and user setup by abelleisle";

  inputs = {
    # Pin our primary nixpkgs repository. This is the main nixpkgs repository
    # we'll use for our configurations. Be very careful changing this because
    # it'll impact your entire system.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";

    # We use the unstable nixpkgs repo for some packages.
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, darwin, ... }@inputs: let
    # Overlays is the list of overlays we want to apply from flake inputs.
    overlays = [
    #   inputs.neovim-nightly-overlay.overlay
    #   inputs.zig.overlays.default
    ];

    mkSystem = import ./lib/mksystem.nix {
      inherit nixpkgs overlays inputs;
    };
  in {
    nixosConfigurations.Eowyn = mkSystem "Eowyn" {
      system = "x86_64-linux";
      user   = "andy";
    };

    darwinConfigurations.Saruman = mkSystem "Saruman" {
      system = "aarch64-darwin";
      user   = "abelleisle";
      darwin = true;
    };
  };
}

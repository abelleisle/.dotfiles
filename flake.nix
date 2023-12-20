{
  description = "NixOS workstation configs and user setup by abelleisle";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";

    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Use disko to automatically partition disks
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    nixos-hardware.url = "github:NixOS/nixos-hardware";
  };

  outputs = { flake-parts, ... } @ inputs:
  (flake-parts.lib.evalFlakeModule { inherit inputs; }
    ({ self, inputs, ... }: {
    systems = [ "x86_64-linux" ];
    imports = [
      ./devshell.nix
      ./configurations.nix
    ];
  })).config.flake;

  # outputs = { self, nixpkgs, disko, nixos-hardware, home-manager, darwin, ... }@inputs: let
  #   # Overlays is the list of overlays we want to apply from flake inputs.
  #   overlays = [
  #   #   inputs.neovim-nightly-overlay.overlay
  #   #   inputs.zig.overlays.default
  #   ];
  #
  #   mkSystem = import ./lib/mksystem.nix {
  #     inherit nixpkgs overlays inputs;
  #   };
  # in {
  #   nixosConfigurations.Eowyn = mkSystem "Eowyn" {
  #     system = "x86_64-linux";
  #     user   = "andy";
  #   };
  #
  #   darwinConfigurations.Saruman = mkSystem "Saruman" {
  #     system = "aarch64-darwin";
  #     user   = "abelleisle";
  #     darwin = true;
  #   };
  # };
}

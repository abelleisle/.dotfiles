{
  description = "Personal Computer Configuration Options";

  # To update inputs:
  # $ nix flake update --recreate-lock-file
  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/release-24.05";

    # Misc. utilities
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixlib.follows = "nixpkgs";
    };

    flake-registry.url = "github:NixOS/flake-registry";
    flake-registry.flake = false;

    # Hardware Configuration
    nixos-hardware.url = "github:NixOS/nixos-hardware";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    # Secrets Management
    agenix.url = "github:ryantm/agenix";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-stable.follows = "nixpkgs";
    };

    # dotfile Management
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Override Flakes
    nixGL = {
      url = "github:nix-community/nixGL";
    };

  };

  outputs = { flake-parts, ... } @ inputs:
  (flake-parts.lib.evalFlakeModule { inherit inputs; }
    ({ self, inputs, ... }: {
    systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" ];
    imports = [
      # ./devShells/flake-module.nix
      # ./pkgs/flake-module.nix
      ./nix/devshell.nix
      ./configurations.nix
    ];
  })).config.flake;
}

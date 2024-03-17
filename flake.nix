{
  description = "Personal Computer Configuration Options";

  # To update inputs:
  # $ nix flake update --recreate-lock-file
  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/release-23.11";
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixlib.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware";

    flake-registry.url = "github:NixOS/flake-registry";
    flake-registry.flake = false;

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-stable.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Override flakes
    hyprland = {
      url = "github:hyprwm/Hyprland";
    };

  };

  outputs = { flake-parts, ... } @ inputs:
  (flake-parts.lib.evalFlakeModule { inherit inputs; }
    ({ self, inputs, ... }: {
    systems = [ "x86_64-linux" "aarch64-linux" ];
    imports = [
      # ./devShells/flake-module.nix
      # ./pkgs/flake-module.nix
      ./nix/devshell.nix
      ./configurations.nix
    ];
  })).config.flake;
}

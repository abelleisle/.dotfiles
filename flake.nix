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

    kmonad = {
      url = "git+https://github.com/kmonad/kmonad?submodules=1&dir=nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Secrets Management
    agenix.url = "github:ryantm/agenix";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-stable.follows = "nixpkgs-stable";
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

    # Themes
    catppuccin.url = "github:catppuccin/nix";

    # Programs
    # NOTE: This will require your git SSH access to the repo.
    #
    # WARNING:
    # Do NOT pin the `nixpkgs` input, as that will
    # declare the cache useless. If you do, you will have
    # to compile LLVM, Zig and Ghostty itself on your machine,
    # which will take a very very long time.
    #
    # Additionally, if you use NixOS, be sure to **NOT**
    # run `nixos-rebuild` as root! Root has a different Git config
    # that will ignore any SSH keys configured for the current user,
    # denying access to the repository.
    #
    # Instead, either run `nix flake update` or `nixos-rebuild build`
    # as the current user, and then run `sudo nixos-rebuild switch`.
    ghostty = {
      url = "git+ssh://git@github.com/ghostty-org/ghostty";

      # NOTE: The below 2 lines are only required on nixos-unstable,
      # if you're on stable, they may break your build
      inputs.nixpkgs-stable.follows = "nixpkgs";
      inputs.nixpkgs-unstable.follows = "nixpkgs";
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

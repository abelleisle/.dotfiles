{ self, lib, ... }:
let
  # inherit
  #   (self.inputs)
  #   nixpkgs
  #   flake-registry
  #   nixpkgs-unstable
  #   nixos-hardware
  #   nixos-generators
  #   disko
  #   sops-nix
  #   home-manager
  #   ;

  overlays = [
    (final: prev: {
      wings-pterodactyl = prev.callPackage ./pkgs/wings-pterodactyl {};
    })
  ];

  mkSystem = import ./nix/mkSystem.nix {
    inherit self lib overlays;
  };

in
{
  # VM and host systems
  flake.nixosConfigurations = {
    # Eowyn: Dev Laptop
    Eowyn = mkSystem "Eowyn" "x86_64-linux"
      { allowUnfree = true; user = "andy"; };

    # Faramir: Dev VM
    Faramir = mkSystem "Faramir" "x86_64-linux"
      { allowUnfree = true; user = "andy"; isVM = true; isBareMetal = false; };

  };
}

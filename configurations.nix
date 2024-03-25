{ self, lib, ... }:
let
  nixos-hw = self.inputs.nixos-hardware.nixosModules;

  overlays = [
    self.inputs.nixGL.overlay
  ];

  mkSystem = import ./nix/mkSystem.nix {
    inherit self lib overlays;
  };

  mkHome = import ./nix/mkHome.nix {
    inherit self lib overlays;
  };
in
{
  flake = {
    # VM and host systems
    nixosConfigurations = {
      # Eowyn: Dev Laptop
      Eowyn = mkSystem "Eowyn" "x86_64-linux"
        { allowUnfree = true;
          user = "andy";
          extraModules = [
            nixos-hw.lenovo-thinkpad-e14-intel
          ];
        };

      # Faramir: Dev VM
      Faramir = mkSystem "Faramir" "x86_64-linux"
        { allowUnfree = true;
          user = "andy";
          isVM = true;
          isBareMetal = false;
        };

    };

    # Homes
    homeConfigurations = {
      # TODO: find a way to get host system value instead of hardcoding
      "andy@Galadriel" = mkHome "andy" "x86_64-linux"
        { extraImports = [ ./nix/users/andy/Galadriel.nix ]; };

      "andy@Eowyn" = mkHome "andy" "x86_64-linux"
        { extraImports = [ ./nix/users/andy/Eowyn.nix ]; };
    };
  };
}

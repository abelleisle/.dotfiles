{ self, lib, ... }:
let
  nixos-hw = self.inputs.nixos-hardware.nixosModules;
  kmonad = self.inputs.kmonad.nixosModules;

  overlays = [
    self.inputs.nixGL.overlay
    (final: prev: {
      # ghostty = self.inputs.ghostty.packages.${prev.system}.default;
    })
  ];

  unfree_whitelist = [
    "uhk-agent"
  ];

  mkSystem = import ./nix/mkSystem.nix {
    inherit self lib overlays unfree_whitelist;
  };

  mkHome = import ./nix/mkHome.nix {
    inherit self lib overlays unfree_whitelist;
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
            kmonad.default
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
        { extraImports = [ ./users/andy/Galadriel.nix ]; };

      "andy@Eowyn" = mkHome "andy" "x86_64-linux"
        { extraImports = [ ./users/andy/Eowyn.nix ]; };

      "andy@Saruman" = mkHome "abelleisle" "aarch64-darwin"
        { extraImports = [ ./users/abelleisle/Saruman.nix ]; };
    };
  };
}

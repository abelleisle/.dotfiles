{ self, ... }:
let
  inherit
    (self.inputs)
    nixpkgs
    nixpkgs-unstable
    flake-registry
    nixos-hardware
    nixos-generators
    home-manager
    darwin
    disko
    ;

  nixosSystem = nixpkgs.lib.nixosSystem;
  darwinSystem = darwin.lib.darwinSystem;
  hmLinux = home-manager.nixosModules;
  hmDarwin = home-manager.darwinModules;

  commonModules = [
    {
      _module.args.self = self;
      _module.args.inputs = self.inputs;
    }
    # ./modules/users.nix
    # ./modules/packages.nix
  ];

  linuxCommon =
    commonModules
    ++ [
    ./modules/sshd.nix
  ];

  darwinCommon =
    commonModules
    ++ [
  ];
in
{
  flake = {
    nixosConfigurations = {
      Eowyn = nixosSystem {
        modules =
          linuxCommon
          ++ [
            ./machines/Eowyn.nix
            ./users/andy/linux.nix
            
            # There is a bug in nixos-hardware that causes infinite recursion
            # if placed within a module. So it's placed here..
            nixos-hardware.nixosModules.lenovo-thinkpad-e14-intel

            hmLinux.home-manager {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              # home-manager.users."andy" = import ./config/home.nix {
              #   inputs = self.inputs;
              #   user = "andy";
              #   hostname = "Eowyn";
              # };
              home-manager.users."andy".imports = [
                (import ./config/home.nix {
                  inputs = self.inputs;
                  user = "andy";
                  hostname = "Eowyn";
                })
                (import ./machines/Eowyn/home.nix {
                  inputs = self.inputs;
                  user = "andy";
                  hostname = "Eowyn";
                })
              ];
            }
          ];
        system = "x86_64-linux";
      };

      Galadriel = nixosSystem {
        modules =
          linuxCommon
          ++ [
            ./users/andy/linux.nix
          ];
        system = "x86_64-linux";
      };
    };

    darwinConfigurations = {
      Saruman = darwinSystem {
        modules =
          darwinCommon
          ++ [
            ./users/abelleisle/darwin.nix
          ];
        system = "aarch64-darwin";
      };
    };
  };
}

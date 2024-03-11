{ self, lib, ... }:
let
  inherit
    (self.inputs)
    nixpkgs
    flake-registry
    nixpkgs-unstable
    nixos-hardware
    nixos-generators
    disko
    sops-nix
    home-manager
    ;

  overlays = [
    (final: prev: {
      wings-pterodactyl = prev.callPackage ./pkgs/wings-pterodactyl {};
    })
  ];

  mkSystem = hostname: system:
    { isBareMetal ? true
    , isVM ? false
    , isLXC ? false
    , user ? "andy"
    , allowUnfree ? false
    , extraModules ? []
    , darwin ? false
    }:
    assert lib.assertMsg
      ((isVM != isLXC) != isBareMetal)
      "System (${hostname}) must be one of: LXC, VM, or baremetal.";
    let

      commonSettings = {
        time.timeZone = lib.mkDefault "UTC";
        nix = {
          nixPath = [
            "nixpkgs=${pkgs.path}"
            "nixpkgs-unstable=${pkgs-unstable.path}"
          ];

          extraOptions = ''
            experimental-features = nix-command flakes
            flake-registry = ${flake-registry}/flake-registry.json
            keep-outputs = true
            keep-derivations = true
          '';

          registry = {
            nixpkgs.flake = nixpkgs;
          };

          # Automatically clean the nix store of old derivations every Tuesday
          # at 10:30 UTC (5:30 EST).
          gc = {
            automatic = true;
            dates = "Tue 10:30";
            options = "--delete-older-than 30d";
          };

          # Automatically optimise the nix store an hour after garbage
          # collection at 11:30 UTC (6:30 EST);
          optimise = {
            automatic = true;
            dates = [
              "Tue 11:30"
            ];
          };
        };
      };

      pkgs = import nixpkgs {
        inherit system overlays;
        config.allowUnfree = allowUnfree;
      };

      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
      };

      specialArgs = {
        inherit pkgs-unstable;
      };

      userOSConfig = ./nix/users/${user}/${if darwin then "darwin" else "linux"}.nix;
      hm = if darwin
        then home-manager.darwinModules
        else home-manager.nixosModules;

    in nixpkgs.lib.nixosSystem
    {
      inherit system pkgs specialArgs;

      modules =
        lib.optionals isVM vmModules ++
        lib.optionals isLXC lxcModules ++
        lib.optionals isBareMetal bareMetalModules ++
        [
          ./nix/machines/${hostname}/configuration.nix
        ]
        ++ [commonSettings]
        ++ [userOSConfig]
        ++ extraModules
        ++ [
          hm.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${user} = import ./nix/users/${user}/home.nix;
          }
        ];
    };

  commonModules = [
    {
      _module.args.self = self;
      _module.args.inputs = self.inputs;
    }
    # ./modules/users/admins.nix
    # ./modules/users/extra-opts.nix
    ./nix/modules/sshd.nix
    ./nix/modules/packages.nix
    # ./modules/networking/hosts.nix
    # ./modules/networking/ip.nix

    # (import ./modules/sops.nix { inherit sops-nix flake-registry nixpkgs; })
  ];

  vmModules =
    commonModules
    ++ [
    ./nix/modules/bootloader.nix
    # ./modules/disks/disko-ext4.nix
    ./nix/modules/vm.nix

    disko.nixosModules.disko
  ];

  lxcModules =
    commonModules
    ++ [
    # ./modules/lxc.nix
  ];

  bareMetalModules =
    commonModules
    ++ [
    ./nix/modules/bootloader.nix
  ];
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

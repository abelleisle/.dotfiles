# NixOS args
{ self
, lib
, flake-registry
, nixpkgs
, nixpkgs-unstable
, home-manager
, disko
, overlays
}:

# Required args
hostname: system:

# Optional args
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

  commonModules = [
    {
      _module.args.self = self;
      _module.args.inputs = self.inputs;
    }
    # ./modules/users/admins.nix
    # ./modules/users/extra-opts.nix
    ./modules/sshd.nix
    ./modules/packages.nix
    # ./modules/networking/hosts.nix
    # ./modules/networking/ip.nix

    # (import ./modules/sops.nix { inherit sops-nix flake-registry nixpkgs; })
  ];

  vmModules =
    commonModules
    ++ [
    ./modules/bootloader.nix
    # ./modules/disks/disko-ext4.nix
    ./modules/vm.nix

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
    ./modules/bootloader.nix
  ];

  userOSConfig = ./users/${user}/${if darwin then "darwin" else "linux"}.nix;
  hm = if darwin
    then home-manager.darwinModules
    else home-manager.nixosModules;

  homeModules = [
    hm.home-manager {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.${user} = {
        imports = [
          ./users/${user}/home.nix
          ./machines/${hostname}/home.nix
        ];
      };
    }
  ];

  commonSettings = {
    time.timeZone = lib.mkDefault "UTC";
    nix = {
      nixPath = [
        "nixpkgs=${pkgs.path}"
        "nixpkgs-unstable=${pkgs-unstable.path}"
      ];

      trusted-users = [ "root" "@wheel" ];

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

in nixpkgs.lib.nixosSystem
{
  inherit system pkgs specialArgs;

  modules =
    lib.optionals isVM vmModules ++
    lib.optionals isLXC lxcModules ++
    lib.optionals isBareMetal bareMetalModules ++
    [
      ./machines/${hostname}/configuration.nix
    ]
    ++ [commonSettings]
    ++ [userOSConfig]
    ++ homeModules
    ++ extraModules;
}

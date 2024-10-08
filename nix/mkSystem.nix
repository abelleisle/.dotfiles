# NixOS args
{ self
, overlays
, lib
, unfree_whitelist
}:

# Required args
hostname: system:

# Optional args
{ isBareMetal ? true
, isVM ? false
, isLXC ? false
, isHeadless ? false
, user ? "andy"
, allowUnfree ? false
, extraModules ? []
, darwin ? false
}:
assert lib.assertMsg
  ((isVM != isLXC) != isBareMetal)
  "System (${hostname}) must be one of: LXC, VM, or baremetal.";
let

  inputs = self.inputs;

  agenixMod = if darwin
    then inputs.agenix.darwinModules
    else inputs.agenix.nixosModules;

  commonModules = [
    {
      config._module.args = {
        self = self;
        inputs = inputs;
        currentSystem = system;
        currentHostname = hostname;
        inherit isVM isBareMetal isLXC;
      };
    }

    # ./modules/users/admins.nix
    # ./modules/users/extra-opts.nix
    ../modules/service/sshd.nix
    ../modules/packages.nix
    # ./modules/networking/hosts.nix
    # ./modules/networking/ip.nix

    # (import ./modules/sops.nix { inherit sops-nix flake-registry nixpkgs; })
    agenixMod.default
    inputs.catppuccin.nixosModules.catppuccin
  ];

  vmModules =
    commonModules
    ++ [
    ../modules/system/bootloader.nix
    # ./modules/disks/disko-ext4.nix
    ../modules/system/vm.nix

    inputs.disko.nixosModules.disko
  ];

  lxcModules =
    commonModules
    ++ [
    # ./modules/lxc.nix
  ];

  bareMetalModules =
    commonModules
    ++ [
    ../modules/system/bootloader.nix
  ];

  uiModules = [
    ../modules/ui # User interface definitions
  ];

  userOSConfig = ../users/${user}/${if darwin then "darwin" else "linux"}.nix;
  hm = if darwin
    then inputs.home-manager.darwinModules
    else inputs.home-manager.nixosModules;

  homeModules = [
    hm.home-manager {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.extraSpecialArgs = {
        inherit pkgs-stable;
      };
      home-manager.users.${user} = {
        imports = [
          inputs.catppuccin.homeManagerModules.catppuccin
        ];
      };
    }
  ];

  commonSettings = {
    time.timeZone = lib.mkDefault "UTC";
    nix = {
      nixPath = [
        "nixpkgs=${pkgs.path}"
        "nixpkgs-stable=${pkgs-stable.path}"
      ];

      settings = {
        trusted-users = [ "root" "@wheel" ];
      };

      extraOptions = ''
        experimental-features = nix-command flakes
        flake-registry = ${inputs.flake-registry}/flake-registry.json
        keep-outputs = true
        keep-derivations = true
      '';

      registry = {
        nixpkgs.flake = inputs.nixpkgs;
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

  pkgs = import inputs.nixpkgs {
    inherit system overlays;
    config = {
      inherit allowUnfree;
      allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) unfree_whitelist;
    };
  };

  pkgs-stable = import inputs.nixpkgs-stable {
    inherit system;
    config.allowUnfree = allowUnfree;
  };

  specialArgs = {
    inherit pkgs-stable;
  };

in inputs.nixpkgs.lib.nixosSystem
{
  inherit system pkgs specialArgs;

  modules =
    lib.optionals isVM vmModules ++
    lib.optionals isLXC lxcModules ++
    lib.optionals isBareMetal bareMetalModules ++
    lib.optionals (!darwin && !isHeadless) uiModules ++
    [
      {
        networking.hostName = "${hostname}"; # Force hostname setting
        system.stateVersion = "24.05";       # Nixpkgs is based on 24.05
      }
      ../machines/${hostname}/configuration.nix
      ../machines/${hostname}/hardware.nix
    ]
    ++ [commonSettings]
    ++ [userOSConfig]
    ++ homeModules
    ++ extraModules;
}

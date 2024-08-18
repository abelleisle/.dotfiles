{ lib, isVM, pkgs, ... }:
{
  imports = [
    ./plymouth.nix
  ];

  services = {
    displayManager = {
      sddm = {
        enable = true;
        wayland = {
          enable = true;
        };
      };
    };
    desktopManager = {
      plasma6 = {
        enable = true;
      };
    };
    kmonad = {
      enable = true;
      keyboards = {
        "colemak-d-extended-ansi" = {
          device = "/dev/input/by-path/platform-i8042-serio-0-event-kbd";
          config = builtins.readFile ./keymaps/colemak-d-extend-ansi.kbd;
        };
      };
    };
  };

  hardware.enableRedistributableFirmware = true;

  programs.hyprland = {
    enable = true;
  };

  environment = {
    sessionVariables = lib.mkIf (isVM) {
      WLR_RENDERER_ALLOW_SOFTWARE = "1";
    };
    plasma6.excludePackages = with pkgs.kdePackages; [
      konsole
      konqueror
    ];
  };

  networking.networkmanager = {
    enable = true;
    wifi = {
      powersave = true;
    };
  };
}

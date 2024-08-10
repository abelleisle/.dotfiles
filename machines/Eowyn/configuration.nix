{ lib, isVM, pkgs, ... }:
{
  imports = [];

  services = {
    displayManager.sddm = {
      enable = true;
      wayland = {
        enable = true;
      };
    };
    desktopManager = {
      plasma6 = {
        enable = true;
      };
    };
  };

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

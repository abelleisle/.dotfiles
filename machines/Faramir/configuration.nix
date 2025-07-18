{ pkgs, inputs, ... }:
{
  imports = [
    # ../../../programs/wm/hyprland.nix
    # ../../../programs/wm/sddm.nix
  ];

  services = {
    # Use sddm (wayland) as the greeter
    displayManager = {
      sddm = {
        enable = true;
        wayland = {
          enable = true;
        };
      };
    };

    # Install plasma6
    desktopManager = {
      plasma6 = {
        enable = true;
      };
    };
  };
}

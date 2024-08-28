{ pkgs, ... }:
{
  ############################
  # Power management

  # Enable powertop
  powerManagement.powertop.enable = true;
  environment.systemPackages = [
    pkgs.powertop
  ];

  # Enable TLP
  services.tlp = {
    enable = false;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

      # CPU_MIN_PERF_ON_AC = 0;
      # CPU_MAX_PERF_ON_AC = 100;
      # CPU_MIN_PERF_ON_BAT = 0;
      # CPU_MAX_PERF_ON_BAT = 20;

      START_CHARGE_THRESH_BAT0 = 72;
      STOP_CHARGE_THRESH_BAT0 = 80;
    };
  };

  # Enable thermald
  services.thermald.enable = true;

  # Bug with wireplumber that causes camera to stay powered 24/7
  # This disables the camera monitor
  services.pipewire.wireplumber.extraConfig."10-disable-camera-monitor" = {
    "wireplumber.profiles" = {
      main = {
        "monitor.libcamera" = "disabled";
      };
    };
  };
}

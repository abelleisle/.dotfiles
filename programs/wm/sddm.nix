{ ... }:
{
  # Enable SDDM
  services.xserver = {
    enable = true;
    displayManager.sddm = {
      enable = true;
    };
  };
}

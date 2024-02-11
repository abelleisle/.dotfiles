{ config, pkgs, lib, ... }:
{
  services.openssh = {
    # By default this is disabled for security.
    # Nodes can enable it manually if required.
    enable = lib.mkDefault true;

    # Use port 22 (probably a bad idea)
    ports = [22];

    settings = {
        # Since dev machines can be used on public WiFi, disable password auth.
        PasswordAuthentication = false;

        # We shouldn't ever need to log in as root
        PermitRootLogin = "no";

        # Disable this to avoid bringing in X11
        X11Forwarding = false;
    };
  };
}

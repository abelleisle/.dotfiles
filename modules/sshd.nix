{ config, pkgs, lib, ... }:
{
  services.openssh = {
    enable = true;
    settings = {
        PasswordAuthentication = true;
        PermitRootLogin = "no";
    };
  };
}

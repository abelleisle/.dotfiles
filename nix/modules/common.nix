{ config, pkgs, lib, ... }: {

  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs = true
      keep-derivations = true
    '';
  };

  environment.systemPackages = with pkgs; [
    git
    asciiquarium
  ];

  services.openssh = {
    enable = true;
    settings = {
        PasswordAuthentication = true;
        PermitRootLogin = "no";
    };
  };
}

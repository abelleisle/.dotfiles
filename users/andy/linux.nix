{ pkgs, currentHostname, lib, config, ... }:
let
  usingNM = config.networking.networkmanager.enable;
in
{
  config = {
    programs.zsh.enable = true;

    users.users.andy = {
      isNormalUser = true;
      home = "/home/andy";
      extraGroups = [ "docker" "wheel" "wireshark" ]
        ++ lib.optionals (usingNM) ["networkmanager" ];
      shell = pkgs.zsh;
    };

    home-manager.users."andy" = {
      imports = [
        ./home.nix
        ./${currentHostname}.nix
      ];
    };

  };

}

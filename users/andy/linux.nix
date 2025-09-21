{ pkgs, currentHostname, lib, config, ... }:
let
  usingNM = config.networking.networkmanager.enable;
in
{
  config = {
    programs = {
      # Enable zsh
      zsh = {
        enable = true;
        enableCompletion = false; # We manage this with zinit
      };

      # Enable/install git
      git = {
        enable = true;
        prompt.enable = true; # Enable git-prompt.sh
      };
    };

    users.users.andy = {
      isNormalUser = true;
      home = "/home/andy";
      description = "Andy";
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

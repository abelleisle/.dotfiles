{ pkgs, currentHostname, ... }:
{
  config = {
    programs.zsh.enable = true;

    users.users.andy = {
      isNormalUser = true;
      home = "/home/andy";
      extraGroups = [ "docker" "wheel" "wireshark" ];
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

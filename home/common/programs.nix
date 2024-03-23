{ pkgs, ... }:
{
  home.packages = [
    # Protonmail support
    pkgs.protonmail-bridge
  ];

  programs = {
    # Librewolf
    librewolf = {
      enable = true;
    };

    # Thunderbird
    thunderbird = {
      enable = true;
    };
  };
}

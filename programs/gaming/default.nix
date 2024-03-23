{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    webcord
  ];

  programs = {
    steam = {
      enable = true;
    };
  };
}

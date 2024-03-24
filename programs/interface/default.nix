{ pkgs, ... }:
{
  options = {

  };

  imports = [
    ./windowManager.nix
    ./displayManager.nix
  ];

  config = {
    fonts.packages = with pkgs; [
      (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })
    ];
  };
}

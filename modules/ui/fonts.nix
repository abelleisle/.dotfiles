{ pkgs, ... }:
{
  config = {
    fonts.packages = with pkgs; [
      # (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })
      nerd-fonts.droid-sans-mono
      nerd-fonts.fira-code
    ];
  };
}

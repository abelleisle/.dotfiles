{ pkgs-unstable, ... }:
{
  programs.helix = {
    enable = true;
    package = pkgs-unstable.helix;
    settings = {
      theme = "gruvbox_dark_hard";

      editor = {
        scrolloff = 10;
        line-number = "relative";

        cursor-shape = {
          normal = "block";
          insert = "bar";
          select = "underline";
        };

        indent-guides = {
          render = true;
          character = "│";
          skip-levels = 0;
        };
      };

      keys = {
        insert = {
          z.x = "normal_mode";
        };
      };
    };
  };
}

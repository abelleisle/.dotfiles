{ ... }:
{
  programs.helix = {
    enable = true;
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
        normal = {
          ";" = "repeat_last_motion";
        };
        insert = {
          z.x = "normal_mode";
        };
      };
    };
  };
}

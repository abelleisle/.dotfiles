{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.dotfiles.programs;
in
with lib;
{
  options = {
    # Enable email programs
    dotfiles.programs.email.enable = mkOption {
      type = types.bool;
      description = "Enable personal email programs";
    };
  };

  config = mkIf (cfg.personal.enable && cfg.email.enable) {
    home.packages = [
      # Protonmail support
      pkgs.protonmail-bridge
    ];

    programs = {
      # Thunderbird
      thunderbird = {
        enable = true;
        # Personal email profile
        profiles = {
          "personal" = {
            isDefault = true;
          };
        };
        settings = {
          # Sort mail top (newest) -> down (oldest)
          "mailnews.default_sort_order" = 2;
          "mailnews.default_sort_type" = 22;
          # Sort news top (newest) -> down (oldest)
          "mailnews.default_news_sort_order" = 2;
          "mailnews.default_news_sort_type" = 22;
          # Enable DNT header
          "privacy.donottrackheader.enabled" = true;
        };
      };
    };
  };
}

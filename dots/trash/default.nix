{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.dotfiles.features.trash;

  dotsLocation = config.dotfiles.dotDir;
  symlink = config.lib.file.mkOutOfStoreSymlink;

  opencodeInstall =
    if dotsLocation != null then dotsLocation + "/dots/trash/opencode/" else ./opencode;
in
{
  options.dotfiles.features.trash = {
    enable = lib.mkEnableOption "Should this user enable trash (AI)";
    opencode = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Should opencode be enabled?";
    };
    claude-code = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Should claude-code be enabled?";
    };
    ollama = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Should ollama be enabled?";
    };
  };

  config = lib.mkIf cfg.enable {
    xdg.configFile = {
      # Opencode
      "opencode" = {
        source = symlink opencodeInstall;
        recursive = true;
      };
    };

    home.packages =
      with pkgs;
      lib.optional cfg.opencode opencode
      ++ lib.optional cfg.claude-code claude-code
      ++ lib.optional cfg.ollama ollama;
  };
}

{
  perSystem =
    { pkgs, ... }:
    {
      treefmt = {
        # Enable formatters
        programs = {
          # Nix
          nixfmt = {
            enable = true;
            package = pkgs.nixfmt-rfc-style;
          };
          deadnix.enable = true;
          statix.enable = true;

          # Lua
          stylua.enable = true;
        };

        # Formatter settings
        settings.formatter = {
          stylua = {
            options = [
              "--syntax"
              "LuaJIT"
              "--indent-type"
              "spaces"
              "--indent-width"
              "4"
            ];
          };
        };
      };
    };
}

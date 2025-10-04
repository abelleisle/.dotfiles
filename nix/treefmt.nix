{
  perSystem =
    { pkgs, ... }:
    {
      treefmt = {
        programs = {
          nixfmt = {
            enable = true;
            package = pkgs.nixfmt-rfc-style;
          };
          deadnix.enable = true;
          statix.enable = true;
        };

        settings.formatter = {
          nixfmt = {
            includes = [ "*.nix" ];
          };
        };
      };
    };
}

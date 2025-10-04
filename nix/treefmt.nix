{
  perSystem = { pkgs, ... }: {
    treefmt = {
      programs.nixfmt = {
        enable = true;
        package = pkgs.nixfmt-rfc-style;
      };

      programs.deadnix.enable = true;
      programs.statix.enable = true;

      settings.formatter = {
        nixfmt = {
          includes = [ "*.nix" ];
        };
      };
    };
  };
}
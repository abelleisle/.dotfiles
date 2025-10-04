{
  perSystem =
    { config, ... }:
    {
      pre-commit = {
        check.enable = true;
        settings = {
          hooks = {
            treefmt = {
              enable = true;
              package = config.treefmt.build.wrapper;
              pass_filenames = false;
            };

            deadnix.enable = true;
            statix.enable = true;
          };
        };
      };
    };
}

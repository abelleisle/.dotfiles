{
  perSystem =
    {
      inputs',
      pkgs,
      config,
      ...
    }:
    {
      devShells.default = pkgs.mkShellNoCC {
        inherit (config.pre-commit.devShell) shellHook;
        buildInputs = [
          # Nix Utilities
          pkgs.nixos-rebuild
          pkgs.nixos-generators
          pkgs.home-manager

          # Python dependencies
          # pkgs.python311.pkgs.invoke
          # pkgs.python311.pkgs.deploykit
          # pkgs.python311.pkgs.black
          # pkgs.python311.pkgs.isort

          # Sops stuff
          inputs'.agenix.packages.default
          pkgs.age
          pkgs.sops
          pkgs.yq-go
          pkgs.git-crypt
          pkgs.gnupg

          # Extra utilities
          pkgs.jq
          pkgs.zig
          pkgs.gcc
          pkgs.cargo

        ]
        ++ pkgs.lib.optional pkgs.stdenv.isLinux pkgs.mkpasswd
        ++ config.pre-commit.settings.enabledPackages;

        # shellHook = ''
        #   echo "Lab node development shell"
        #   if [ -x "$(command -v zsh)" ]; then
        #     echo "ZSH is installed!"
        #     echo "Using ZSH for shell"
        #     zsh
        #     exit
        #   else
        #     echo "ZSH is not installed.. Using default nix shell"
        #   fi
        # '';
      };
    };
}

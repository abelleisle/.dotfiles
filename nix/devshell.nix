{ pkgs, ... }:
pkgs.mkShellNoCC {
  buildInputs = [
    # Nix Utilities
    pkgs.nixos-rebuild
    pkgs.nixos-generators

    # Python dependencies
    pkgs.python311.pkgs.invoke
    pkgs.python311.pkgs.deploykit
    pkgs.python311.pkgs.black
    pkgs.python311.pkgs.isort

    # Sops stuff
    pkgs.age
    pkgs.sops
    pkgs.yq-go

    # Extra utilities
    pkgs.jq
  ] ++ pkgs.lib.optional (pkgs.stdenv.isLinux) pkgs.mkpasswd;

  shellHook = ''
    echo "Lab node development shell"
    if [ -x "$(command -v zsh)" ]; then
      echo "ZSH is installed!"
      echo "Using ZSH for shell"
      zsh
      exit
    else
      echo "ZSH is not installed.. Using default nix shell"
    fi
  '';
}
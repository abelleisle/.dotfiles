{ pkgs, config, lib, ... }: {
  environment.systemPackages = with pkgs; [
    # Base packages
    coreutils
    man-pages

    # Extras
    file
    wget
    htop
    ncdu

    # System Management
    git
    stow
    # (neovim.override { vimAlias = true; })

    # Networking
    iperf
  ];

  # Creates /etc/current-system-packages to show all installed packages and versions
  environment.etc."current-system-packages".text =
  let
    packages = builtins.map (p: "${p.name}") config.environment.systemPackages;
    sortedUnique = builtins.sort builtins.lessThan (lib.unique packages);
    formatted = builtins.concatStringsSep "\n" sortedUnique;
  in
    formatted;
}

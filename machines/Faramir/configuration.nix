{ pkgs, inputs, ... }:
{
  imports = [
    ../../../programs/wm/hyprland.nix
    ../../../programs/wm/sddm.nix
  ];

  # How to create disks:
  #
  # sudo parted /dev/vda -- mklabel gpt
  # sudo parted /dev/vda -- mkpart root ext4 512MB -1GB
  # sudo parted /dev/vda -- mkpart swap linux-swap -1GB 100%
  # sudo parted /dev/vda -- mkpart boot fat32 1MB 512MB
  # sudo parted /dev/vda -- set 3 esp on
  #
  # sudo mkfs.ext4 -L root /dev/disk/by-partlabel/root
  # sudo mkswap -L swap /dev/disk/by-partlabel/swap
  # sudo mkfs.fat -F 32 -n boot /dev/disk/by-partlabel/boot
  #
  # sudo mount /dev/disk/by-label/root /mnt
  # sudo mkdir -p /mnt/boot/efi
  # sudo mount /dev/disk/by-label/boot /mnt/boot/efi
  # sudo swapon /dev/disk/by-label/swap
  #
  # sudo nixos-install --flake .#Faramir
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/root";
      fsType = "ext4";
    };

    "/boot/efi" = {
      device = "/dev/disk/by-label/boot";
      fsType = "vfat";
    };
  };

  swapDevices = [
    {
      device = "/dev/disk/by-label/swap";
    }
  ];
}

{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.templates.system.virtualization.virt-manager;
in
{
  options.templates.system.virtualization.virt-manager = with lib; {
    enable = mkEnableOption "Enable virt-manager";
    users = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "List of users to add to libvirtd group";
      example = [
        "alice"
        "bob"
      ];
    };
    pciPassthrough = {
      enable = mkEnableOption "Enable PCI pci passthrough";
      cpu = mkOption {
        type = types.nullOr (
          types.enum [
            "amd"
            "intel"
          ]
        );
        default = null;
        description = "CPU type for PCI passthrough configuration";
        example = "amd";
      };
      extraDrivers = mkOption {
        type = types.listOf types.str;
        default = [ ];
        description = "Extra drivers to load for PCI passthrough";
        example = [
          "vfio-pci"
          "vfio_iommu_type1"
        ];
      };
    };
  };

  config =
    with lib;
    mkIf cfg.enable {
      assertions = [
        {
          assertion = !cfg.pciPassthrough.enable || cfg.pciPassthrough.cpu != null;
          message = "PCI passthrough requires specifying a CPU type (amd or intel)";
        }
      ];
      programs.virt-manager.enable = true;
      virtualisation.spiceUSBRedirection.enable = true;
      virtualisation.libvirtd = {
        enable = true;
        qemu = {
          package = pkgs.qemu_kvm;
          runAsRoot = true;
          swtpm.enable = true;
          # ovmf = {
          #   enable = true;
          #   packages = [
          #     (pkgs.OVMF.override {
          #       secureBoot = true;
          #       tpmSupport = true;
          #     }).fd
          #   ];
          # };
        };
      };

      users.groups.libvirtd.members = cfg.users;
      users.users = lib.genAttrs cfg.users (_user: {
        extraGroups = [ "libvirtd" ];
      });

      boot.initrd.kernelModules = mkIf cfg.pciPassthrough.enable (
        [
          "vfio_pci"
          "vfio"
          "vfio_iommu_type1"
        ]
        ++ cfg.pciPassthrough.extraDrivers
      );

      boot.kernelParams = mkIf cfg.pciPassthrough.enable [
        (if cfg.pciPassthrough.cpu == "intel" then "intel_iommu=on" else "amd_iommu=on")
      ];
    };
}

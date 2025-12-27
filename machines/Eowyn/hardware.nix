{ pkgs, ... }:
{
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/Eroot";
      fsType = "ext4";
    };

    "/boot/efi" = {
      device = "/dev/disk/by-label/Eboot";
      fsType = "vfat";
    };
  };

  swapDevices = [
    {
      device = "/dev/disk/by-label/Eswap";
    }
  ];

  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD"; # Prefer the modern iHD backend
    # VDPAU_DRIVER = "va_gl";      # Only if using libvdpau-va-gl
  };

  hardware = {
    enableRedistributableFirmware = true;
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    graphics = {
      enable = true;
      extraPackages = with pkgs; [
        # Required for modern Intel GPUs (Xe iGPU and ARC)
        intel-media-driver # VA-API (iHD) userspace
        vpl-gpu-rt # oneVPL (QSV) runtime

        # Optional (compute / tooling):
        intel-compute-runtime # OpenCL (NEO) + Level Zero for Arc/Xe
        # NOTE: 'intel-ocl' also exists as a legacy package; not recommended for Arc/Xe.
        # libvdpau-va-gl       # Only if you must run VDPAU-only apps
      ];
    };
  };

  boot.kernelParams = [ "i915.enable_guc=3" ];
  services.xserver.videoDrivers = [ "modesetting" ];
}

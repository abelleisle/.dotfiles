{ pkgs, disko, ... }: {
  options = {
    disko.rootDisk = lib.mkOption {
      type = lib.types.str;
      default = "/dev/sda";
      description = "The device to use for the disk";
    };
  };
  config = {
    disko.devices = {
      disk = {
        vdb = {
          device = config.disko.rootDisk;
          type = "disk";
          content = {
            type = "table";
            format = "gpt";
            partitions = {
              ESP = {
                size = "500M";
                bootable = true;
                content = {
                  type = "filesystem";
                  format = "vfat";
                  mountpoint = "/boot";
                };
              };
              root = {
                size = "100%";
                content = {
                  type = "filesystem";
                  format = "ext4";
                  mountpoint = "/";
                };
              };
            };
          };
        };
      };
    };
  };
}

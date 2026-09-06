{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/nvme0n1";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              priority = 1;
              name = "CFI";
              start = "1MiB";
              end = "1GiB";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
		extraArgs = ["-n" "CFI" ];
                mountOptions = [ "umask=0077" ];
              };
            };
            root = {
              size = "100%";
	      name = "compliance";
              content = {
                type = "btrfs";
                extraArgs = [ "-f" "-L" "compliance" ];
                subvolumes = {
                  "/root" = {
                    mountpoint = "/";
		    mountOptions = [ "compress=zstd" ];
                  };
                  "/home" = {
                    mountOptions = [ "compress=zstd" ];
                    mountpoint = "/home";
                  };
                  "/nix" = {
                    mountOptions = [
                      "compress=zstd"
                      "noatime"
                    ];
                    mountpoint = "/nix";
                  };
		};
              };
            };
          };
        };
      };
    };
  };
}

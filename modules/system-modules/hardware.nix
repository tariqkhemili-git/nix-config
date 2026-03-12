{ config, ... }:

{
  hardware = {
    nvidia = {
      modesetting = {
        enable = true;
      };
      open = true;
      package = config.boot.kernelPackages.nvidiaPackages.latest;
      powerManagement = {
        enable = false;
        finegrained = false;
      };
      prime = {
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
        sync = {
          enable = true;
        };
      };
    };

    graphics = {
      enable = true;
      enable32Bit = true;
    };

    cpu = {
      intel = {
        updateMicrocode = true;
      };
    };
    enableRedistributableFirmware = true;
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
  };
}

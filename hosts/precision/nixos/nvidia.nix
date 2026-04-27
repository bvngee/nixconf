{ config, ... }: {
  hardware.nvidia = {
    nvidiaSettings = true;
    modesetting.enable = true;
    open = true;
    prime = {
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
      offload.enable = true;
      offload.enableOffloadCmd = true;
    };
    powerManagement = {
        enable = true;
        finegrained = true; # TODO: when updating try this again
    };
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
  boot.blacklistedKernelModules = [ "nouveau" ];

  services.xserver.videoDrivers = [ "nvidia" ];
}

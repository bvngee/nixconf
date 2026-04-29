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
    dynamicBoost.enable = true;
    powerManagement = {
      enable = false;
      finegrained = true;
      # TODO: when nixos update includes kernelSuspendNotifier option, set
      # enable to true and remove all the manual stuff below.
      # kernelSuspendNotifier = true;
    };
    package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
      version = "595.58.03";
      sha256_64bit = "sha256-jA1Plnt5MsSrVxQnKu6BAzkrCnAskq+lVRdtNiBYKfk=";
      openSha256 = "sha256-6LvJyT0cMXGS290Dh8hd9rc+nYZqBzDIlItOFk8S4n8=";
      settingsSha256 = "sha256-2vLF5Evl2D6tRQJo0uUyY3tpWqjvJQ0/Rpxan3NOD3c=";
      usePersistenced = false;
    };
  };
  boot.blacklistedKernelModules = [ "nouveau" ];
  boot.kernelParams = [
    # "nvidia.NVreg_PreserveVideoMemoryAllocations=1" # Superseeded by UseKernelSuspendNotifiers
    "nvidia.NVreg_OpenRmEnableUnsupportedGpus=1"
    "nvidia.NVreg_EnableS0ixPowerManagement=1"
    "nvidia.NVreg_UseKernelSuspendNotifiers=1"
    "nvidia.NVreg_TemporaryFilePath=/var/tmp"
  ];

  services.xserver.videoDrivers = [ "nvidia" ];
}

{ config, ... }: {
  # For a more thorough nvidia config, see my pc's nvidia settings.
  # Partially stolen from nixos-hardware
  hardware.nvidia = {
    nvidiaSettings = false;
    modesetting.enable = true;
    powerManagement.enable = false; # not new enough to support this
    open = false;
    prime = {
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
      offload.enable = true;
      offload.enableOffloadCmd = true;
    };
    # nvidia drivers with explicit sync support (as of 555)!
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
  boot.blacklistedKernelModules = [ "nouveau" ];
  #environment.variables.VDPAU_DRIVER = "nvidia";

  services.xserver.videoDrivers = [ "nvidia" ];
}

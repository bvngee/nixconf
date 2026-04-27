{ config, ... }: {
  # Nvidia config for pc's GTX 1650S

  hardware.nvidia = {
    # until https://github.com/NVIDIA/open-gpu-kernel-modules/issues/472 is resolved?
    open = false;

    # suspend/resume; also adds NVreg_PreserveVideoMemoryAllocations=1 kernel param
    powerManagement.enable = true;

    modesetting.enable = true; # also adds nvidia-drm.modeset=1 kernel param

    nvidiaSettings = true;

    # nvidia drivers with explicit sync support (as of 555)!
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # This should be done automatically: https://github.com/NixOS/nixpkgs/blob/0196e5372b8b7a282cb3bbe5cbf446617141ce38/nixos/modules/hardware/video/nvidia.nix#L658C29-L658C34
  #boot.kernelParams = [ "nvidia_drm.fbdev=1" ];
  
  # Make sure we're not uing nouveau
  boot.blacklistedKernelModules = [ "nouveau" ];

  # Note: nvidia-vaapi-driver is added automatically with "nvidia" added to videoDrivers
  hardware.graphics.extraPackages = [ ]; # I don't think vaapiVdpau is necessary? Still not sure
  hardware.graphics.extraPackages32 = [ ];

  # necessary for both X and Wayland based apps
  services.xserver.videoDrivers = [ "nvidia" ];
}

{ lib, config, ... }: {
  # Common configurations for systems with Nvidia GPUs.
  # Mainly system-level env vars that significantly affect rendering.
  environment.sessionVariables =
    let
      inherit (config.host) isNvidia;
    in
    {
      # Force usage of GBM over EGLStreams (the specific buffer API that the gpu
      # driver and wayland compositor communicate with).
      GBM_BACKEND = lib.mkIf (isNvidia) "nvidia-drm";

      # I believe this makes apps that use GLX default to PRIME offload; see `cat $(rpwhich nvidia-offload)`
      # export __GLX_VENDOR_LIBRARY_NAME=nvidia 

      # Hardware acceleration on Nvidia GPUs.
      # If there is an internal iGPU (in which case PRIME offload should be
      # enabled), then always prefer the iGPU for video acceleration.
      LIBVA_DRIVER_NAME =
        let
          hasNvidiaPRIME = config.hardware.nvidia.prime.offload.enable;
          nvidiaWithInteliGPU = (builtins.stringLength config.hardware.nvidia.prime.intelBusId) > 1 && isNvidia;
          nvidiaWithAMDiGPU = (builtins.stringLength config.hardware.nvidia.prime.amdgpuBusId) > 1 && isNvidia;
        in
        assert !(nvidiaWithInteliGPU && nvidiaWithAMDiGPU);

        if hasNvidiaPRIME
        then
          (
            if nvidiaWithInteliGPU
            then "iHD" else
              (
                # Verify: is `radeonsi` correct for AMD iGPUs?
                if nvidiaWithAMDiGPU
                then "radeonsi" else
                  (throw "Prime offload found with unknown iGPU")
              )
          )
        else
          if isNvidia
          then "nvidia"
          else (throw "I've only dealt with systems with Nvidia GPUs and/or Nvidia PRIME. Figure out how to set LIBVA hw accel for other DGPUs?");

      # Tell the nvidia-vaapi-driver to use the direct backend instead of egl. Always the correct option.
      NVD_BACKEND = "direct";

      # G-Sync / Variable Refresh Rate (VRR) settings. See
      # https://wiki.hypr.land/Configuring/Environment-variables/#nvidia-specific
      __GL_GSYNC_ALLOWED = lib.mkIf (isNvidia) 1;
      __GL_VRR_ALLOWED = lib.mkIf (isNvidia) 0;

    };
}

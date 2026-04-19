# Custom configuration for Dell Precision laptop
{ lib, pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
    ./nvidia.nix
  ];

  # Stolen from nixos-hardware
  boot.kernelParams = [ "i915.enable_fbc=1" "i915.enable_psr=2" ]; # "i915.modeset=1" is apparently deprecated

  # Force i915 driver to load BEFORE anything nvidia-related. Fixes a race
  # condition that causes anything chromium-based to take multiple minutes
  # to start and to spam literal gigabytes of journal logs. See:
  # https://forums.developer.nvidia.com/t/550-54-14-cannot-create-sg-table-for-nvkmskapimemory-spammed-when-launching-chrome-on-wayland/284775/37
  # https://www.reddit.com/r/archlinux/comments/1cn10w4/nvidia_drm_cannot_create_sg_table_message_spam_in/
  # https://issues.chromium.org/issues/351095641
  boot.kernelModules = lib.mkOrder 100 [ "i915" ];

  hardware.graphics.extraPackages = [ pkgs.intel-media-driver ];
  hardware.graphics.extraPackages32 = [ pkgs.pkgsi686Linux.intel-media-driver ];

  system.stateVersion = "24.05";
}

# Custom configuration for Dell Precision laptop
# See: www.delltechnologies.com/asset/en-ie/products/workstations/technical-support/precision-5490-spec-sheet.pdf
{ pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
    ./nvidia.nix
  ];

  boot.kernelParams = [
    # Experiment: try new intel igpu driver. TODO: when update to newer kernel, try this again!!
    # "i915.force_probe=!7d55"
    # "xe.force_probe=7d55"
  ];

  hardware.graphics.extraPackages = [ pkgs.intel-media-driver ];
  hardware.graphics.extraPackages32 = [ pkgs.pkgsi686Linux.intel-media-driver ];

  # To enroll: `fprintd-enroll`
  services.fprintd.enable = true;

  system.stateVersion = "25.11";
}

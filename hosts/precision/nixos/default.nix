# Custom configuration for Dell Precision laptop
# See: www.delltechnologies.com/asset/en-ie/products/workstations/technical-support/precision-5490-spec-sheet.pdf
{ pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
    ./nvidia.nix
  ];

  boot.kernelParams = [];

  hardware.graphics.extraPackages = [ pkgs.intel-media-driver ];
  hardware.graphics.extraPackages32 = [ pkgs.pkgsi686Linux.intel-media-driver ];

  system.stateVersion = "25.11";
}

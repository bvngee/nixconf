# Custom configuration for Dell Precision laptop
# See: <todo: add pdf link>
{ lib, pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
    ./nvidia.nix
  ];

  boot.kernelParams = [];

  hardware.graphics.extraPackages = [ pkgs.intel-media-driver ];
  hardware.graphics.extraPackages32 = [ pkgs.pkgsi686Linux.intel-media-driver ];

  system.stateVersion = "25.11";
}

# Custom configuration for Thinkpad T15
{ pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
  ];

  hardware.graphics.extraPackages = [ pkgs.intel-media-driver ];
  hardware.graphics.extraPackages32 = [ pkgs.pkgsi686Linux.intel-media-driver ];

  boot.kernelParams = [ "psmouse.synaptics_intertouch=0" ];

  system.stateVersion = "26.05";
}

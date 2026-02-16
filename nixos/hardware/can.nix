# To get the socketCAN interface up and running with a CAN-to-USB adapter, run
# this command (assuming a 500kbaud CAN bus):
#
# $ sudo ip link set up can0 type can bitrate 500000

{ self, config, pkgs, ... }: {

  # Kernel module containing HMS Ixxat socketCAN drivers. Downloaded from
  # https://www.hms-networks.com/support/general-downloads. The tarball
  # contained multiple drivers; This is only `ix_usb_can_2.0.xxx-REL.tgz`,
  # for "all USB-to-CAN V2 and USB-to-CAN-FD family adapters".
  boot.extraModulePackages = [
    (self.packages.${pkgs.stdenv.hostPlatform.system}.ix_usb_can.override {
      kernel = config.boot.kernelPackages.kernel;
    })

    (self.packages.${pkgs.stdenv.hostPlatform.system}.supercan_usb.override {
      kernel = config.boot.kernelPackages.kernel;
    })
  ];
  boot.kernelModules = [ "ix_usb_can" "supercan_usb" ];

  environment.systemPackages = with pkgs; [
    # CLI tools for interfacing with socketCAN interfaces
    can-utils

    # GUI tool for interfacing with socketCAN interfaces
    savvycan
  ];
}

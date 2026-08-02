{ pkgs, ... }: {
  # Installs linux-firmware and a bunc of other things, but not the proprietary
  # ones like XBox One or various Broadcome devices.
  # Alternatively, we could enable:
  # # hardware.enableAllFirmware = true;
  hardware.enableRedistributableFirmware = true;

  # https://fwupd.org/
  services.fwupd.enable = true;

  # GUI for managing fwupd (checking and installing firmware)
  environment.systemPackages = with pkgs; [
    gnome-firmware
  ];

  hardware.wirelessRegulatoryDatabase = true;
}

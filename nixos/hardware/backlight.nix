{ pkgs, pkgsUnstable, config, ... }: {
  environment.systemPackages = with pkgs; [
    # Generic screen brightness control
    brightnessctl
    # External monitor backlight control via ddc
    ddcutil

    # Daemon, CLI, and GUI to manage ddc i2c devices (TODO: 26.11)
    pkgsUnstable.ddccontrol
  ];

  # Required for DDC backlight brightness control
  hardware.i2c.enable = true;
  users.users.${config.host.mainUser}.extraGroups = [ "i2c" ];

    # Daemon, CLI, and GUI to manage ddc i2c devices
  services.ddccontrol.enable = true;
  services.ddccontrol.package = pkgsUnstable.ddccontrol;
} 

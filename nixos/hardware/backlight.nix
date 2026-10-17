{ lib, pkgs, config, ... }:
let
  inherit (config.host) isNvidia;
in
{

  # TODO: script this somehow, in a bar or something:
  # `for dir in /sys/class/backlight/*; do brightnessctl s 5%- -d "${dir##*/}" & done`
  # for some reason brightnessctl isnt seeing all monitors so that might be necessary

  environment.systemPackages = with pkgs; [
    # Generic screen brightness control
    brightnessctl
    # External monitor backlight control via ddc
    ddcutil
  ];

  # For anything connecting to an external monitor: install ddcci-driver which
  # controls external monitor brightness using standard brightness protocol.
  boot = {
    extraModulePackages = [ config.boot.kernelPackages.ddcci-driver ];
    kernelModules = [ "ddcci" "ddcci-backlight" "i2c-dev" ];
  };

  # If the system has an Nvidia GPU, the ddcci kernel module will most likely not
  # autodetect monitors as supporting DDC. This somewhat ugly hack is needed as
  # a workaround.
  # https://gitlab.com/ddcci-driver-linux/ddcci-driver-linux/-/issues/7#note_151296583
  # TODO: this sometimes doesn't work or only works partially? (not sure if related to the upgrade to 555)
  services.udev.extraRules = lib.mkIf (isNvidia) ''
    SUBSYSTEM=="i2c-dev", ACTION=="add",\
    ATTR{name}=="NVIDIA i2c adapter*",\
    TAG+="ddcci",\
    TAG+="systemd",\
    ENV{SYSTEMD_WANTS}+="ddcci@$kernel.service"
  '';

  systemd.services."ddcci@" = lib.mkIf (isNvidia) {
    description = "ddcci handler";
    after = [ "graphical.target" ];
    before = [ "shutdown.target" ];
    conflicts = [ "shutdown.target" ];
    serviceConfig = {
      Type = "oneshot";
      Restart = "no";
      ExecStart = ''
        ${pkgs.bash}/bin/bash -c 'echo Trying to attach ddcci to %i && success=0 && i=0 && id=$(echo %i | cut -d "-" -f 2) && while ((success < 1)) && ((i++ < 5)); do ${pkgs.ddcutil}/bin/ddcutil getvcp 10 -b $id && { success=1 && echo ddcci 0x37 > /sys/bus/i2c/devices/%i/new_device && echo "ddcci attached to %i"; } || sleep 5; done'
      '';
    };
  };

} 

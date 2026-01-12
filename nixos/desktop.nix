{ config, lib, pkgs, ... }: {
# Common configurations shared between all desktop-nixos variations.

  # We use the tzupdate service for automatic imperative timezone setting based
  # on geolocation. Sets `time.timeZone to null`
  services.tzupdate.enable = true;
  services.tzupdate.timer.enable = true;
  services.tzupdate.timer.interval = "hourly";

  i18n.defaultLocale = "en_US.UTF-8";

  console = {
    packages = with pkgs; [ terminus_font ];
    earlySetup = true;
    #font = "Lat2-Terminus16";
    font = "${pkgs.terminus_font}/share/consolefonts/ter-v24n.psf.gz";
    keyMap = "us";
  };

  # Enable all documentation (incl. developer-specific stuff)
  documentation = {
    enable = true;
    man.enable = true;
    man.generateCaches = true;
    info.enable = true;
    doc.enable = true;
    dev.enable = true;
  };

  environment.systemPackages = with pkgs; [
    man-pages # Linux development man pages
    git # Useful when debugging
  ];

  # So I can use flatpaks if I ever (rarely) need to
  services.flatpak.enable = true;

  # Installs the appimage-run script, and registers it to be called
  # automativally via binfmt when trying to run appimages
  programs.appimage.enable = true;
  programs.appimage.binfmt = true;

  fonts.enableDefaultPackages = true;

  # Dbus implementation that's supposed to bring higher perf and compatibility
  services.dbus.implementation = "broker";

  # Used for apps that depend on a dbus secret-service provider
  services.gnome.gnome-keyring.enable = true; # prefer this over Kwallet

  # Let pam_gnome_keyring auto-unlock the user's default gnome keyring on login
  security.pam.services.login.enableGnomeKeyring = true;
  security.pam.services.greetd.enableGnomeKeyring = true;
  security.pam.services.tuigreet.enableGnomeKeyring = true;

  # (polkitd is enabled from somewhere else already, but I'll keep this anyways)
  # Manage unpriviledged processes' access to priviledged processes
  security.polkit.enable = true;

  # Necessary to set GTK related settings (eg. to set themes)
  programs.dconf.enable = true;

  # Dbus service for accessing info about user accounts
  services.accounts-daemon.enable = true;

  # Hands out realtime scheduling priority to user processes on demand
  security.rtkit.enable = true;

  # Enable screen lockers to actually unlock the screen (are these really needed?)
  security.pam.services.hyprlock = { };
  security.pam.services.swaylock = { };

  # Dbus service that allows applications to query and manipulate storage devices
  services.udisks2.enable = true;
  services.udisks2.mountOnMedia = true; # mounts drives at /media/ instead of /run/media/$user

  # A system profiler app (not even sure if I'll use this but it looks neat)
  services.sysprof.enable = true;

  # Modify how laptop lidSwitch/powerKey is handled
  services.logind = lib.mkIf (config.host.isMobile) {
    lidSwitch = "suspend";
    lidSwitchDocked = "ignore";
    lidSwitchExternalPower = "suspend";
    powerKey = "sleep";
    powerKeyLongPress = "poweroff";
  };
}

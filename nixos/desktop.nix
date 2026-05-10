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

  # Pluggable Authentication Modules.
  # Services typically correspond to programs (swaylock), and rules are steps
  # that PAM must take for that service to complete its authentication.
  security.pam.services =
    let
      servicesToAddFprintdPasswdRule =
        if config.services.fprintd.enable
        then [ "sudo" "polkit-1" "swaylock" "hyprlock" ]
        else [ ];
    in
    {
      # Greetd supports unique service files per greeter, but only needs to find
      # the default "greetd" service file by default (https://github.com/kennylevinsen/greetd/blob/d3b45e7398d3eed65b39c532c713ea052a5b9278/greetd/src/config/mod.rs#L67)

      # Let pam_gnome_keyring auto-unlock the user's default gnome keyring on login
      login.enableGnomeKeyring = true;
      greetd.enableGnomeKeyring = true;

      # Don't use pam_fprintd first login manager. This will be removed
      # eventually anyways, as it breaks pam_gnome_keyring auto_start
      # (which forces password prompts later anyways) and it's also just
      # a significantly increased security risk (https://gitlab.freedesktop.org/libfprint/fprintd/-/work_items/23)
      login.fprintAuth = false;
      greetd.fprintAuth = false;

      # Enable screen lockers to actually unlock the screen (are these really needed?)
      hyprlock = { };
      swaylock = { };
    }
    // (lib.mergeAttrsList (lib.map
      (s: {
        # The following is a solution to make the pam_fprint experience better in
        # GUI apps (swaylock/hyprlock, polkit agents) where you want to also enter
        # your password. This makes it so you must FIRST enter your password, or
        # press enter which then prompts you for fingerprint.
        # Unfortunately, the PAM auth is sequential by design, so this sucks no
        # matter what. Se my comment here:
        # https://github.com/linux-pam/linux-pam/issues/301#issuecomment-4412173045
        # Here for the solution:
        # https://github.com/swaywm/swaylock/issues/61#issuecomment-965175390
        # https://wiki.archlinux.org/title/Fprint#Login_configuration
        ${s}.rules.auth.unix-before-fprintd = {
          enable = true;
          order = config.security.pam.services.${s}.rules.auth.fprintd.order - 10;
          control = "sufficient";
          modulePath = "${pkgs.linux-pam}/lib/security/pam_unix.so";
          settings = {
            likeauth = true;
            nullok = true;
            try_first_pass = true;
            nodelay = false;
          };
        };
      })
      servicesToAddFprintdPasswdRule));

  # (polkitd is enabled from somewhere else already, but I'll keep this anyways)
  # Manage unpriviledged processes' access to priviledged processes
  security.polkit.enable = true;

  # Necessary to set GTK related settings (eg. to set themes)
  programs.dconf.enable = true;

  # Dbus service for accessing info about user accounts
  services.accounts-daemon.enable = true;

  # Hands out realtime scheduling priority to user processes on demand
  security.rtkit.enable = true;

  # Dbus service that allows applications to query and manipulate storage devices
  services.udisks2.enable = true;
  services.udisks2.mountOnMedia = true; # mounts drives at /media/ instead of /run/media/$user

  # A system profiler app (not even sure if I'll use this but it looks neat)
  services.sysprof.enable = true;

  # Modify how laptop lidSwitch/powerKey is handled
  services.logind.settings.Login = lib.mkIf (config.host.isMobile) {
    HandleLidSwitch = "suspend";
    HandleLidSwitchDocked = "ignore";
    HandleLidSwitchExternalPower = "suspend";
    HandlePowerKey = "suspend";
    HandlePowerKeyLongPress = "poweroff";
  };
}

{ pkgsUnstable, config, pkgs, ... }: {
  home.packages = with pkgs; [
    # Image, video
    kdePackages.gwenview
    mpv
    imv
    gimp
    inkscape
    zathura

    # Office Suite
    onlyoffice-desktopeditors
    libreoffice

    # Chat apps
    vesktop
    element-desktop
    fractal
    zulip
    zulip-term

    # Misc/Other
    obs-studio
    firefox
    ungoogled-chromium
    zoom-us
    gnome-calendar
    gnome-calculator
    gnome-notes
    gnome-font-viewer
    gnome-control-center # this is NOT intended to be used outside Gnome, but still has some useful features
    file-roller # better default over kde's ark?
    gnome-disk-utility # Udisk graphical front end
    baobab # disk utilization viewer (gtk)
    gparted # partition manager
    seahorse # GUI for managing gnome-keyring entries
    kdePackages.kcalc
    mission-center
    snapshot
    crosspipe # pipewire graph thingy
    pavucontrol
    showmethekey # shows keys typed in a little gui
    qbittorrent
    freecad
    kicad

    # Davinci Resolve only lets you use your Studio key on a select # of machines
    (if config.host.hostname == "pc" then davinci-resolve-studio else davinci-resolve)
  ];

  services = { };

  xdg.autostart.entries = [
    # Note: Installed in nixos/programs/bitwarden.nix due to
    # https://github.com/nix-community/home-manager/issues/5559
    "${pkgsUnstable.bitwarden-desktop}/share/applications/bitwarden.desktop"
  ];
}

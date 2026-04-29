{ inputs, config, pkgs, ... }: {
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

    # Password manager
    bitwarden-desktop
    bitwarden-cli

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
    helvum # pipewire graph thingy
    pavucontrol
    showmethekey # shows keys typed in a little gui
    qbittorrent
    freecad

    # Davinci Resolve only lets you use your Studio key on a select # of machines
    (if config.host.hostname == "pc" then davinci-resolve-studio else davinci-resolve)

    # Kicad 9.0.8, contains the fix for readonly sym/fp lib tables from 9.0.6.
    inputs.nixpkgs-kicad.legacyPackages.${pkgs.stdenv.hostPlatform.system}.kicad
  ];

  services = { };
}

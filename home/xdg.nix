{ config, ... }: {
  xdg.enable = true;

  xdg.mimeApps = rec {
    enable = true;
    associations.added = defaultApplications;
    defaultApplications =
      let
        browser = [ "firefox.desktop" ];
      in
      {
        "text/html" = browser;
        "x-scheme-handler/http" = browser;
        "x-scheme-handler/https" = browser;
        "x-scheme-handler/ftp" = browser;
        "x-scheme-handler/about" = browser;
        "x-scheme-handler/unknown" = browser;
        "x-scheme-handler/element" = [ "element-desktop.desktop" ];
        "x-scheme-handler/terminal" = "com.mitchellh.ghostty.desktop";
        "application/x-extension-htm" = browser;
        "application/x-extension-html" = browser;
        "application/x-extension-shtml" = browser;
        "application/xhtml+xml" = browser;
        "application/x-extension-xhtml" = browser;
        "application/x-extension-xht" = browser;
        "application/json" = browser;

        #"application/x-xz-compressed-tar" = ["org.kde.ark.desktop"];
        "application/x-xz-compressed-tar" = [ "org.kde.ark.desktop" ];

        "audio/*" = [ "mpv.desktop" ];
        "video/*" = [ "mpv.desktop" ];
        "image/*" = [ "gwenview.desktop" ]; # imv.desktop?

        "inode/directory" = [ "thunar.desktop" ];
      };
  };

  # Hopefully this fixes the constant override warnings?
  xdg.configFile."mimeapps.list".force = true;

  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    setSessionVariables = true;
    extraConfig = {
      SCREENSHOTS = "${config.xdg.userDirs.pictures}/Screenshots";
    };
  };

  xdg.autostart = {
    enable = true;
    # Prevent random apps from writing xdg autostart files. This way only HM
    # moduels can add autostart entries
    readOnly = true;
  };

  xdg.terminal-exec = {
    enable = true;
    settings = {
      default = [ "com.mitchellh.ghostty.desktop" ];
    };
  };
}

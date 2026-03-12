{ pkgs, ... }: {
  programs.nix-ld = {
    enable = true;
    package = pkgs.nix-ld;

    # See defaults here: https://github.com/NixOS/nixpkgs/blob/5bb0c5ac60d5dc25c08ce3910ff75ea1da0e4026/nixos/modules/programs/nix-ld.nix#L44-L59
    libraries = with pkgs; [
      # Stolen from https://github.com/Mic92/dotfiles/blob/57cf7fdf8705a5362fc19114b8395cdbf7668e94/nixos/modules/nix-ld.nix#L6-L58
      alsa-lib
      at-spi2-atk
      at-spi2-core
      atk
      cairo
      cups
      curl
      dbus
      expat
      fontconfig
      freetype
      fuse3
      gdk-pixbuf
      glib
      gtk3
      gtk2
      icu
      libGL
      libappindicator-gtk3
      libdrm
      libglvnd
      libnotify
      libpulseaudio
      libunwind
      libusb1
      libuuid
      libxkbcommon
      libxml2
      libxslt
      libsecret
      flite
      mesa
      nspr
      nss
      openssl
      pango
      pipewire
      stdenv.cc.cc
      systemd
      libgcrypt
      libudev0-shim
      libgbm
      vulkan-loader
      wayland
      xorg.libX11
      xorg.libXScrnSaver
      xorg.libXcomposite
      xorg.libXcursor
      xorg.libXdamage
      xorg.libXext
      xorg.libXfixes
      xorg.libXi
      xorg.libXrandr
      xorg.libXrender
      xorg.libXtst
      xorg.libxcb
      xorg.libxkbfile
      xorg.libxshmfence
      xorg.libSM
      xorg.libICE
      xorg.xcbutilkeysyms
      xorg.xcbutilimage
      xorg.xcbutilrenderutil
      xorg.xcbutilwm
      xorg.xcbutilerrors
      xorg.xcbutilerrors
      zlib
      orc
    ];
  };
}

{ pkgs, ... }: {
  programs.steam = {
    enable = true;

    # in a Steam game's launch options: `gamescope -W 2560 -H 1440 -- %command%`
    gamescopeSession.enable = true;

    # steam override that allows to work with gamescope # is this needed?
    package = pkgs.steam.override {
      extraPkgs = pkgs: with pkgs; [
        libxcursor
        libxi
        libxinerama
        libxscrnsaver
        libpng
        libpulseaudio
        libvorbis
        stdenv.cc.cc.lib
        libkrb5
        keyutils
      ];
    }; 
    extraCompatPackages = [
      pkgs.proton-ge-bin
    ];
  };

  programs.gamemode.enable = true;

  environment.systemPackages = with pkgs; [
    gamescope 

    mangohud

    protontricks
    winetricks
    wine

    # Games
    lunar-client
    # note: glfw-wayland-minecraft might require __GL_THREADED_OPTIMIZATIONS=0 on nvidia
    # https://github.com/glfw/glfw/issues/2510#issuecomment-2002622024
    prismlauncher
  ];
}

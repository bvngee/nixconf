{ pkgs, ... }: {
  home.packages = with pkgs; [
    xclip
    xss-lock
    dex
    xdotool
    xwd
  ];
}

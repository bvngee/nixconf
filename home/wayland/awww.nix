{ pkgs, ... }: let
  wallpaperScript = pkgs.writeShellScriptBin "apply_wallpaper" ''
    wallpaper=$1
    awww img \
      --transition-type wipe \
      --transition-angle 22 \
      --transition-step 100 \
      --transition-duration 3.5 \
      --transition-fps 75 \
      --transition-bezier .53,0,.37,.99 \
      $wallpaper
    notify-send "Switched wallpaper to $(basename $wallpaper)!" -i $wallpaper
  '';
  randomWallpaperScript = pkgs.writeShellScriptBin "apply_random_wallpaper" ''
    wallpaper_dir=$1
    wallpaper="$(find $wallpaper_dir -type f | shuf -n 1)"
    awww img \
      --transition-type wipe \
      --transition-angle 22 \
      --transition-step 100 \
      --transition-duration 3.5 \
      --transition-fps 75 \
      --transition-bezier .53,0,.37,.99 \
      $wallpaper
    notify-send "Switched wallpaper to $(basename $wallpaper)!" -i $wallpaper
  '';
in {

  home.packages = with pkgs; [
    libnotify
    awww

    wallpaperScript
    randomWallpaperScript
  ];

}

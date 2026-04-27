{ pkgs, lib, ... }: {
  # Variables that should be set for ALL wayland sessions, but NOT for x11 sessions.
  # This script is sourced by the display manager (currently tuigreet) for
  # wayland sessions.
  environment.etc."wayland-session-wrapper.sh".source =
    pkgs.writeShellScript "wayland-session-wrapper" (lib.concatStringsSep "\n\n\n" [
      ''
        # Toolkit-specific environment variables
        export GDK_BACKEND=wayland,x11
        export QT_QPA_PLATFORM="wayland;xcb"
        export QT_AUTO_SCREEN_SCALE_FACTOR=1
        export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
        export _JAVA_AWT_WM_NONEREPARENTING=1
        export SLD_VIDEODRIVER=wayland
        export CLUTTER_BACKEND=wayland
      
        # Nixpkgs adds ozone (chromium) wayland flags to a bunch of apps if this
        # env var is set.
        export NIXOS_OZONE_WL=1
      ''

      ''
        # Home manager sets our sessionVariables via shell configurations, but
        # doesn't control the login sequence, and we don't use a fancy Login
        # Manager that would source these variables for us. So we manually
        # source Home Manager's session variables here, so that compositors can
        # have them too (eg. QT_QPA_PLATFORMTHEME).
        source "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
      ''

      ''
        # Execute wayland compositor from positional args, piping output into
        # systemd journal (is $1 always correct?).
        systemd-cat -t "$1" "$@"
      ''
    ]);
}

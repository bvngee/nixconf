{ pkgsUnstable, ... }: {
  # Enable hyprland. Plugins are added via the home manager module.
  programs.hyprland = {
    enable = true;
    # I prefer not having a python wrapper around my compositors. I use the
    # basic sytemd target from the Hyprland HM module instead
    withUWSM = false;
    # TODO(hyprland 0.56.1+)
    package = pkgsUnstable.hyprland;
  };
  xdg.portal = {
    config.hyprland = {
      # Note: hyprland.enable doesthis already. Kept for explicitness sake
      default = [ "hyprland" "gtk" ];
    };
  };
}

{ lib, config, ... }: {
  home = {
    username = config.host.mainUser;
    homeDirectory = "/home/${config.host.mainUser}";
    stateVersion = config.host.stateVersion;
  };

  # I've heard it's common these fail to build (not sure if necessary anymore)
  manual = {
    manpages.enable = true;
    html.enable = false;
    json.enable = false;
  };

  # Less noisy and WAY FASTER home-manager CLI
  news = {
    display = "silent";
    entries = lib.mkForce [ ];
  };

  # Adds the home-manager cli tool to home.packages (for standalone mode).
  # Note: to initialize standalone home-manager for the first time, run
  # something like `nix run home-manager/release-24.05 -- switch --flake .#user@hostname`
  programs.home-manager.enable = true;

  # Some default programs
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    BROWSER = "firefox";
    TERMINAL = "kitty";
    MANPAGER = "nvim +Man\!";
  };
}

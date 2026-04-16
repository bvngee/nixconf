{ inputs, pkgs, ... }: {
  # Cli/Tui tools and commands
  home.packages = with pkgs; [
    ripgrep
    tree
    nix-prefetch-scripts # for bzr, cvs, git, hg, svn
    nix-prefetch-github # for fetchFromGitHub
    nix-prefetch-docker # for dockerTools.pullImage
    nix-output-monitor # nom
    file
    btop
    htop
    neofetch
    fastfetch
    pfetch-rs
    unzip
    trash-cli
    zip
    jq
    yq # (jq but for yaml/xml/toml)
    zf
    killall
    unixtools.xxd
    wget
    curl
    socat
    dig
    traceroute
    screen
    nmap
    lm_sensors
    usbutils
    pciutils
    tokei
    #nvtopPackages.full # uncomment in future? throwing annoying trace warnings
    inotify-tools
    inotify-info # script that shows all active watches
    playerctl
    libnotify
    glib
    lsof
    progress
    ffmpeg
    ncdu # disk utilization viewer. Command: `sudo ncdu / --exclude-kernfs --exclude-caches --confirm-quit --exclude /nix/store`
    graphviz
    calc # cli calculator. See `c` alias in home/shell/default.nix
    dotenv-cli
    net-tools
    pandoc
  ];

  programs = {
    # cli fuzzy finder with nice shell integrations
    fzf = {
      enable = true;
      enableZshIntegration = true;
      defaultCommand = "fd --hidden"; # Using fd makes fzf waaaay faster
      defaultOptions = [
        "--height 40%"
        "--bind 'ctrl-u:half-page-up'"
        "--bind 'ctrl-d:half-page-down'"
        "--bind 'change:top'"
      ];

      # for ALT-C keybind (cd)
      changeDirWidgetCommand = "fd --no-hidden --type d";
      # too noisy:
      # changeDirWidgetOptions = "--preview 'eza --icons --tree {} | head -200'";

      # for CTRL-T keybind (find file or directory)
      fileWidgetCommand = "fd --hidden"; # this shows hidden files, do I want that?
      # for CTRL-R keybind (command history search)
      historyWidgetOptions = [ "--tiebreak=begin,chunk" ];
    };

    # faster/simpler `find` alternative
    fd = {
      enable = true;
      extraOptions = [ "--hidden" ];
    };

    # fancy ls
    eza = {
      enable = true;
      enableZshIntegration = true;
      extraOptions = [ "--group-directories-first" ];
      icons = "auto";
    };

    # the best navigation tool ever (replaces cd)
    zoxide = {
      enable = true;
      enableZshIntegration = true;
      options = [ ];
    };

    # for faster nix shell workflows
    direnv = {
      enable = true;
      nix-direnv.enable = true;
      enableZshIntegration = true;
    };

    # faster tldr client
    tealdeer = {
      enable = true;
      settings = {
        display = {
          compact = false;
          use_pager = false;
        };
        updates = {
          auto_update = true;
        };
      };
    };
  };


  imports = [
    # enables programs.nix-index with prebuilt database, and provides options below
    inputs.nix-index-database.homeModules.nix-index
  ];

  programs.nix-index = {
    symlinkToCacheHome = true;
    # annoying and slow command-not-found behavior
    enableZshIntegration = false;
    enableBashIntegration = false;
  };
  # I prefer this
  programs.nix-index-database.comma.enable = true;
}

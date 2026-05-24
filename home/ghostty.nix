{ pkgs, config, ... }: {
  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;
    # Spawns app-com.mitchellh.ghostty.service at graphical-session.target, to
    # make gtk-single-instance work immediately instead of after first window
    systemd.enable = true;
  };

  xdg.configFile."ghostty/config".text =
    let
      customCSS = pkgs.writeText "ghostty-custom.css" ''
        headerbar {
            min-height: 10px;
            padding: 0;
            margin: 0;
        }

        revealer.raised.bottom-bar {
            /* Make default shadow a bit weaker (lower alpha) (todo: this might make light theme harder to see */
            box-shadow: 0 -1px color(srgb 0 0 0.023 / 0.1), 0 -2px 4px color(srgb 0 0 0.023 / 0.1);

            /* Part 1 of disabling dim-on-unfocus */
            background-color: rgba(0,0,0,0);
        }

        revealer windowhandle {
            /* Part 2 of disabling dim-on-unfocus */
            filter: none;
        }

        tabbar tabbox {
            margin: -4px -10px;
            padding: 0;
            min-height: 10px;
            font-family: Hack Nerd Font;
            -gtk-icon-size: 14px;

            /*background-color: #181926;*/
        }

        tabbar tabbox tab {
            margin: 0;
            padding: 0;
            /*background-color: #1e2030;*/
            /*color: #cad3f5;*/
            border-radius: 0px;
            
            /* Make tab transition instant */
            transition-duration: 0s;
        }

        tabbar tabbox separator {
            /*background-color: #000000;*/
        }

        tabbar tabbox tab:selected {
            padding: 0px;
        }

        tabbox tab button image {
            /* Hack: the button is still there just invisible until you hover over it */
            opacity: 0;
            min-width: 0;
        }

        tabbar tabbox tab label {
            font-size: 14px;
        }

        tabbar tabbox tab:selected label {
            font-style: italic;
            font-weight: bold;
        }
      '';
    in
    with config.scheme.withHashtag; ''
      window-decoration = false
      font-family = "Hack Nerd Font"
      background-opacity = 1.0
      font-size = 11
      cursor-style-blink = false
      cursor-style = block
      shell-integration-features = sudo,no-cursor,ssh-env
      adjust-cursor-thickness = 1
      quit-after-last-window-closed = false
      gtk-tabs-location=bottom
      gtk-toolbar-style=raised
      gtk-custom-css = ${customCSS}
    
      foreground = ${base05}
      background = ${base00}
      selection-foreground = ${base00}
      selection-background = ${base05}
      cursor-color = ${base05}

      # normal
      palette = 0=${base00}
      palette = 1=${base08}
      palette = 2=${base0B}
      palette = 3=${base0A}
      palette = 4=${base0D}
      palette = 5=${base0E}
      palette = 6=${base0C}
      palette = 7=${base05}
      
      # bright
      palette = 8=${base03}
      palette = 9=${base08}
      palette = 10=${base0B}
      palette = 11=${base0A}
      palette = 12=${base0D}
      palette = 13=${base0E}
      palette = 14=${base0C}
      palette = 15=${base07}

      # extended base16 colors
      palette = 16=${base09} 
      palette = 17=${base0F}
      palette = 18=${base01}
      palette = 19=${base02}
      palette = 20=${base04}
      palette = 21=${base06}    
    '';
}

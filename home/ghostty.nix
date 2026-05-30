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
      gtk-tabs-location = bottom
      gtk-toolbar-style = raised
      gtk-wide-tabs = false
      window-new-tab-position = end
      app-notifications = no-clipboard-copy
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
        
      # clear default keybinds; add back the ones I want plus some of my own
      keybind = clear

      # keybind = super+ctrl+shift+arrow_down=resize_split:down,10
      # keybind = super+ctrl+shift+arrow_left=resize_split:left,10
      # keybind = super+ctrl+shift+arrow_right=resize_split:right,10
      # keybind = super+ctrl+shift+arrow_up=resize_split:up,10
      # keybind = super+ctrl+shift+j=write_screen_file:copy,plain
      # keybind = ctrl+alt+shift+j=write_screen_file:open,plain
      # keybind = super+ctrl+[=goto_split:previous
      # keybind = super+ctrl+]=goto_split:next
      # keybind = ctrl+alt+arrow_down=goto_split:down
      # keybind = ctrl+alt+arrow_left=goto_split:left
      # keybind = ctrl+alt+arrow_right=goto_split:right
      # keybind = ctrl+alt+arrow_up=goto_split:up
      # keybind = ctrl+shift+,=reload_config
      # keybind = ctrl+shift+enter=toggle_split_zoom
      keybind = ctrl+shift+tab=previous_tab
      keybind = ctrl+shift+page_down=jump_to_prompt:1
      keybind = ctrl+shift+page_up=jump_to_prompt:-1
      keybind = ctrl+shift+arrow_left=previous_tab
      keybind = ctrl+shift+arrow_right=next_tab
      keybind = ctrl+shift+a=select_all
      keybind = ctrl+shift+c=copy_to_clipboard:mixed
      # keybind = ctrl+shift+e=new_split:down
      keybind = ctrl+shift+f=start_search
      # keybind = ctrl+shift+i=inspector:toggle
      # keybind = ctrl+shift+j=write_screen_file:paste,plain
      # keybind = ctrl+shift+n=new_window
      # keybind = ctrl+shift+o=new_split:right
      keybind = ctrl+shift+p=toggle_command_palette
      # keybind = ctrl+shift+q=quit
      keybind = ctrl+shift+t=new_tab
      keybind = ctrl+shift+v=paste_from_clipboard
      keybind = ctrl+shift+w=close_tab:this
      # keybind = alt+digit_1=goto_tab:1
      # keybind = alt+digit_2=goto_tab:2
      # keybind = alt+digit_3=goto_tab:3
      # keybind = alt+digit_4=goto_tab:4
      # keybind = alt+digit_5=goto_tab:5
      # keybind = alt+digit_6=goto_tab:6
      # keybind = alt+digit_7=goto_tab:7
      # keybind = alt+digit_8=goto_tab:8
      # keybind = alt+1=goto_tab:1
      # keybind = alt+2=goto_tab:2
      # keybind = alt+3=goto_tab:3
      # keybind = alt+4=goto_tab:4
      # keybind = alt+5=goto_tab:5
      # keybind = alt+6=goto_tab:6
      # keybind = alt+7=goto_tab:7
      # keybind = alt+8=goto_tab:8
      keybind = ctrl+shift+digit_1=goto_tab:1
      keybind = ctrl+shift+digit_2=goto_tab:2
      keybind = ctrl+shift+digit_3=goto_tab:3
      keybind = ctrl+shift+digit_4=goto_tab:4
      keybind = ctrl+shift+digit_5=goto_tab:5
      keybind = ctrl+shift+digit_6=goto_tab:6
      keybind = ctrl+shift+digit_7=goto_tab:7
      keybind = ctrl+shift+digit_8=goto_tab:8
      keybind = ctrl+shift+1=goto_tab:1
      keybind = ctrl+shift+2=goto_tab:2
      keybind = ctrl+shift+3=goto_tab:3
      keybind = ctrl+shift+4=goto_tab:4
      keybind = ctrl+shift+5=goto_tab:5
      keybind = ctrl+shift+6=goto_tab:6
      keybind = ctrl+shift+7=goto_tab:7
      keybind = ctrl+shift+8=goto_tab:8
      keybind = alt+9=last_tab
      # keybind = alt+f4=close_window
      keybind = ctrl++=increase_font_size:1
      keybind = ctrl+,=open_config
      keybind = ctrl+-=decrease_font_size:1
      keybind = ctrl+0=reset_font_size
      # keybind = ctrl+enter=toggle_fullscreen
      keybind = ctrl+==increase_font_size:1
      keybind = ctrl+tab=next_tab
      # keybind = ctrl+insert=copy_to_clipboard:mixed
      # keybind = ctrl+page_down=next_tab
      # keybind = ctrl+page_up=previous_tab
      # keybind = shift+end=scroll_to_bottom
      # keybind = shift+home=scroll_to_top
      # keybind = shift+insert=paste_from_selection
      # keybind = shift+page_down=scroll_page_down
      # keybind = shift+page_up=scroll_page_up
      # keybind = shift+arrow_down=adjust_selection:down
      # keybind = shift+arrow_left=adjust_selection:left
      # keybind = shift+arrow_right=adjust_selection:right
      # keybind = shift+arrow_up=adjust_selection:up
      keybind = ctrl+shift+end=scroll_to_bottom
      keybind = ctrl+shift+home=scroll_to_top
      # keybind = ctrl+shift+insert=paste_from_selection
      keybind = ctrl+shift+page_down=scroll_page_down
      keybind = ctrl+shift+page_up=scroll_page_up
      keybind = ctrl+shift+arrow_down=adjust_selection:down
      keybind = ctrl+shift+arrow_left=adjust_selection:left
      keybind = ctrl+shift+arrow_right=adjust_selection:right
      keybind = ctrl+shift+arrow_up=adjust_selection:up
      keybind = performable:escape=end_search
      keybind = copy=copy_to_clipboard:mixed
      keybind = paste=paste_from_clipboard

      keybind = ctrl+shift+.=move_tab:1
      keybind = ctrl+shift+,=move_tab:-1
    '';
}

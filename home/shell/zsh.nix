{ config, lib, pkgs, ... }: {
  programs.zsh = {
    enable = true;
    autocd = true;
    dotDir = "${config.xdg.configHome}/zsh";
    history = {
      path = "${config.xdg.dataHome}/zsh_history";
      # I like my history
      size = 1000000;
      save = 1000000;
      # Add timestamps
      extended = true;
      expireDuplicatesFirst = true;
      ignoreDups = true;
      ignoreSpace = true;
      append = true;
      # Instead, I set INC_APPEND_HISTORY_TIME. See https://zsh.sourceforge.io/Doc/Release/Options.html#History
      share = false;
    };
    initContent =
      let
        zshExtraConfigEarlyInit = lib.mkBefore ''
          # automatically called by zsh-vi-mode plugin
          function zvm_config() {
            ZVM_READKEY_ENGINE=$ZVM_READKEY_ENGINE_NEX # required for below
            ZVM_ESCAPE_KEYTIMEOUT=0.001
            ZVM_VI_SURROUND_BINDKEY=s-prefix
            ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT

            # no clue whatsoever how this works, but it makes visual mode look ok
            ZVM_VI_HIGHLIGHT_BACKGROUND="white" #\033[
            ZVM_VI_HIGHLIGHT_FOREGROUND="\033["
          }

          # set normal/visual mode keybindings here, as they might conflict with zsh-vi-mode
          function zvm_after_lazy_keybindings() {
            bindkey -M vicmd 'k' history-substring-search-up
            bindkey -M vicmd 'j' history-substring-search-down
          }

          function zvm_after_init() {
            # needs to be here to work around zsh-vi-mode
            bindkey '^ ' autosuggest-accept
            bindkey '^y' autosuggest-accept

            # TODO: no it doesn't. Investigate fixes again
            # bindkey 'A' autosuggest-clear # fixes conflict with zsh-vi-mode!!

            # for some reason it seems like this is the only keybind that gets
            # overriden by ZVM. /shrug
            bindkey -M viins '^R' fzf-history-widget
          }

          # if ZSH_PROFILE is set, do profiling
          if [ "$ZSH_PROFILE" -eq 1 ]; then
            zmodload zsh/zprof
          fi
        '';
        zshExtraConfig = ''
          setopt INC_APPEND_HISTORY_TIME

          flakify() {
            if [ ! -e flake.nix ]; then
              curl -OL https://raw.githubusercontent.com/Bvngee/nix-flake-template/main/flake.nix
              curl -OL https://raw.githubusercontent.com/Bvngee/nix-flake-template/main/.envrc
              echo "Added flake.nix/.envrc template!"
            fi
            # $${EDITOR:-vim} flake.nix
          }

          # Fix for "zsh: corrupt history file"
          fixCorruptZshHistory() {
            history 0 | sed -E 's/^ *[0-9]* *(.*)$/\1/' > ~/.local/share/zsh_history
            # OR
            # mv ~/.local/share/zsh_history ~/.local/share/zsh_history_bad
            # strings ~/.local/share/zsh_history_bad > ~/.local/share/zsh_history
            # fc -R ~/.local/share/zsh_history 
            # rm ~/.local/share/zsh_history_bad  
          }

          # stolen from https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/fancy-ctrl-z
          fancy-ctrl-z() {
            if [[ $#BUFFER -eq 0 ]]; then
              BUFFER="fg"
              zle accept-line -w
            else
              zle push-input -w
              zle clear-screen -w
            fi
          }
          zle -N fancy-ctrl-z
          bindkey '^Z' fancy-ctrl-z

          # https://junegunn.github.io/fzf/tips/ripgrep-integration/#wrap-up
          rgi() (
            RELOAD='reload:rg --column --color=always --smart-case {q} || :'
            OPENER='if [[ $FZF_SELECT_COUNT -eq 0 ]]; then
                      vim {1} +{2}     # No selection. Open the current line in Vim.
                    else
                      vim +cw -q {+f}  # Build quickfix list for the selected items.
                    fi'
            fzf --disabled --ansi --multi \
                --bind "start:$RELOAD" --bind "change:$RELOAD" \
                --bind "enter:become:$OPENER" \
                --bind "ctrl-o:execute:$OPENER" \
                --bind 'alt-a:select-all,alt-d:deselect-all,ctrl-/:toggle-preview' \
                --delimiter : \
                --preview 'bat --style=full --color=always --highlight-line {2} {1}' \
                --preview-window '~4,+{2}+4/3,<80(up)' \
                --query "$*"
          )

          # https://github.com/haslersn/any-nix-shell (zsh-nix-shell alternative)
          # TODO: Is there a way to disable this for `nix develop` when I want
          # to debug packages? It's nice for devshells, not so nice for package
          # debugging. Atm solution: go into bash first, then `nix develop`.
          ${pkgs.any-nix-shell}/bin/any-nix-shell zsh | source /dev/stdin
        '';
        zshExtraConfigLast = lib.mkAfter ''
          # zsh-syntax-highlighting configuration
          ZSH_HIGHLIGHT_HIGHLIGHTERS=(main) # add future additional highlighters here
          typeset -A ZSH_HIGHLIGHT_STYLES
          ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=red' # remove bold
          ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=cyan' # cyan string color.
          ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=cyan' # does this work with
          ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg=cyan' # all color schemes?
          ZSH_HIGHLIGHT_STYLES[path]=none # remove annoying underlines (?)
          ZSH_HIGHLIGHT_STYLES[path_prefix]=none

          bindkey '^[[A' history-substring-search-up
          bindkey '^[[B' history-substring-search-down

          HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE=1
          HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='underline,bold'
          HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND='underline,bold'

          if [ "$ZSH_PROFILE" -eq 1 ]; then
            zprof
          fi
        '';
      in

      lib.mkMerge [ zshExtraConfigEarlyInit zshExtraConfig zshExtraConfigLast ];

    autosuggestion.enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    historySubstringSearch.enable = true;

    defaultKeymap = "viins";

    plugins = [
      {
        name = "zsh-vi-mode";
        file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
        src = pkgs.zsh-vi-mode;
      }
      {
        name = "zsh-autopair";
        file = "share/zsh/zsh-autopair/autopair.zsh";
        src = pkgs.zsh-autopair;
      }
      # too complex, doesn't integrate well with other plugins, seems hard to configure
      # note: requires `enableCompletion = true;` # from future: did I mean "= false" there? I forget lol
      # {
      #   name = "zsh-autocomplete";
      #   file = "share/zsh-autocomplete/zsh-autocomplete.plugin.zsh";
      #   src = pkgs.zsh-autocomplete;
      # }
    ];
  };
}

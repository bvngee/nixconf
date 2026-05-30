{ config, ... }: {
  programs = {
    gh.enable = true;

    git = {
      enable = true;
      settings = {
        user.name = config.host.mainUserDesc;
        user.email = config.host.mainUserEmail;

        alias.prettylog = "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";

        init.defaultBranch = "main";
        core.askPass = ""; # disabled ridiculous ssh gui password prompt
        # not sure exactly what these do, copied from NotAShelf
        core.whitespace = "fix,-indent-with-non-tab,trailing-space,cr-at-eol";

        # shows both your changes, conflicting changes, and original
        merge.conflictstyle = "diff3";

        # the colors are annoying. Note however that "no" marks moved lines as diffs even if they're unchanged
        # https://git-scm.com/docs/git-diff#Documentation/git-diff.txt---color-movedltmodegt
        diff.colorMoved = "no";

        # I often want to add a shell.nix, .envrc (and thus .direnv/), etc to
        # random projects without seeing the annoying unstaged message in git
        # status (set below)
        core.excludesfile = "~/.config/git/global_gitignore";
      };


    };

    delta = {
      enable = true;
      # sets git's core.pager and interactive.diffFilter
      enableGitIntegration = true;
      options = {
        decorations = {
          commit-decoration-style = "bold yellow box ul";
          file-decoration-style = "none";
          file-style = "bold yellow ul";
          hunk-decoration-style = "bold blue ul";
          hunk-header-style = "omit";
        };
        line-numbers = {
          line-numbers = true;
          line-numbers-minus-style = "brightblack";
          line-numbers-zero-style = "brightblack";
          line-numbers-plus-style = "brightblack";
          line-numbers-left-format = ""; # {nm:>4}┊
          line-numbers-left-style = ""; # brightblack
          line-numbers-right-format = "{np:>4}│";
          line-numbers-right-style = "brightblack";
        };
        features = "decorations line-numbers";
        whitespace-error-style = "22 reverse";
        navigate = true;
        hyprlinks = true;
        syntax-theme = "none";
      };
    };
  };

  # enable scrolling in delta's git diff
  home.sessionVariables.DELTA_PAGER = "less -RF";

  home.shellAliases = {
    g = "git";
    ga = "git add";
    gaa = "git add --all";
    gc = "git commit";
    gco = "git checkout";
    gcm = "git commit -m";
    gca = "git commit --amend";
    gbr = "git branch";
    gs = "git status";
    gsw = "git switch";
    gst = "git stash";
    gd = "git diff";
    gds = "git diff --staged";
    gls = "git ls-files";
    gl = "git prettylog"; # see below, alternative to "git log"
    gp = "git pull";
    gprb = "git pull --rebase";
    gP = "git push";
    gPf = "git push --force";
    grb = "git rebase";
    grbc = "git rebase --continue";
    grba = "git rebase --abort";
    grs = "git reset";
    grsh = "git reset --hard";
    grst = "git restore";
    gm = "git merge";
    gmc = "git merge --continue";
    gma = "git merge --abort";
    gw = "git worktree";
    gwl = "git worktree list";
  };

  xdg.configFile."git/global_gitignore".text = ''
    .envrc
    .direnv/
    # do I want this? Do I want flake.nix/flake.lock too?
    shell.nix
  '';
}

{ pkgs, ... }: {
  # Enables fonts installed via home.packages to be discovered
  fonts.fontconfig.enable = true;
  # Note: If changes to fonts are made and programs are not able to find them, run `fc-cache -f`
  home.packages = with pkgs; [
    nerd-fonts.caskaydia-cove
    nerd-fonts.jetbrains-mono
    nerd-fonts.hack
    roboto
    inter
    noto-fonts
    noto-fonts-cjk-sans
    font-awesome
    corefonts
    vista-fonts
    newcomputermodern
  ];

}

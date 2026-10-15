{ config, pkgs, ... }:
let
  mkLink = relPath:
    config.lib.file.mkOutOfStoreSymlink "${config.host.flakeRoot}/home/static/files/${relPath}";
in
{
  # Some necessary packages related to the static files
  home.packages = with pkgs; [
    (ironbar.overrideAttrs (src: rec {
      version = "0.19.0-149c0d0";
      src = pkgs.fetchFromGitHub {
        repo = "ironbar";
        owner = "JakeStanger";
        rev = "149c0d0d7e26366d066b14878a8e85cf1ee32f42"; # https://github.com/JakeStanger/ironbar/commit/149c0d0d7e26366d066b14878a8e85cf1ee32f42
        sha256 = "sha256-gpAA4YgOMARm0re2a8rlfF5OKCq3VgjznHWnTAn23e4=";
      };
      cargoHash = "sha256-H9KpIUBFVAw7/va438/n2L+QYdMfhzdTgIFr/DJpbgw=";
      cargoDeps = pkgs.rustPlatform.fetchCargoVendor {
        inherit src;
        name = src.name;
        hash = cargoHash;
      };
    }))
    yazi
    joshuto
  ];

  xdg.configFile = {
    "ironbar".source = mkLink "ironbar";
    "joshuto".source = mkLink "joshuto";
    "hypr/hyprland-static.conf".source = mkLink "hypr/hyprland-static.conf";
    "starship.toml".source = mkLink "starship.toml";
    "btop/btop.conf".source = mkLink "btop/btop.conf";
    "i3/config".source = mkLink "i3/config";
    "clangd/config.yaml".source = mkLink "clangd/config.yaml";
    "fuzzel/fuzzel.ini".source = mkLink "fuzzel.ini";
  };

  home.file = {
    ".local/bin/screenshot".source = mkLink "bin/screenshot";
    ".local/bin/screenshotFull".source = mkLink "bin/screenshotFull";
    ".local/bin/toggle_focus_mode_hyprland".source = mkLink "bin/toggle_focus_mode_hyprland";
  };
}

{ self, nixpkgs, inputs }:
let
  # Make a standalone Home Manager configuration.
  # Unlike for `nixosSystem`, `homeManagerConfiguration` does not come from
  # nixpkgs.lib, so we must give home manager the instance of nixpkgs that we
  # want it to use. We can skip specifying `nixpkgs.config` at import-time,
  # as home manager prioritizes the `nixpkgs.config` as discovered by the
  # module system (see modules/common/nixpkgs-config.nix); however, we must
  # still specify `system`, which means duplicating `nixpkgs.hostPlatform` from
  # `hosts/<host>/nixos/hardware-configuration.nix` for each host.
  mkHomeManagerConfig = { system, imports }:
    let
      pkgs = import nixpkgs ({ inherit system; });
    in
    inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [ ../modules ] ++ imports;
      extraSpecialArgs = { inherit self inputs; };
    };

  commonGraphicalHMModules = [
    ../home/home.nix
    ../home/xdg.nix
    ../home/git.nix
    ../home/kdeconnect.nix
    ../home/kitty.nix
    ../home/ghostty.nix
    ../home/dunst.nix
    ../home/spicetify.nix
    ../home/udiskie.nix
    ../home/thunar.nix
    ../home/desktop.nix
    ../home/theme/fonts.nix
    ../home/theme/cursor.nix
    ../home/theme/gtk.nix
    ../home/theme/qt.nix
    ../home/theme/base16.nix
    ../home/theme/matugen.nix

    ../home/programs/cli.nix
    ../home/programs/coding.nix
    ../home/programs/gui.nix
    ../home/wayland
    ../home/x11
    ../home/shell
    ../home/waybar
    ../home/nvim
    ../home/static
  ];
  wslModules = [
    ../modules # source custom modules

    ../home/home.nix
    ../home/xdg.nix
    ../home/git.nix
    ../home/theme/base16.nix

    ../home/programs/cli.nix
    ../home/programs/coding.nix
    ../home/shell
    ../home/nvim
    ../home/static
  ];
in
{
  "jack@pc" = mkHomeManagerConfig {
    system = "x86_64-linux";
    imports = [
      ../hosts/pc/profile.nix
    ] ++ commonGraphicalHMModules;
  };
  "jack@latitude" = mkHomeManagerConfig {
    system = "x86_64-linux";
    imports = [
      ../hosts/latitude/profile.nix
    ] ++ commonGraphicalHMModules;
  };
  "jack@precision" = mkHomeManagerConfig {
    system = "x86_64-linux";
    imports = [
      ../hosts/precision/profile.nix
    ] ++ commonGraphicalHMModules;
  };
  "jack@precision-old" = mkHomeManagerConfig {
    system = "x86_64-linux";
    imports = [
      ../hosts/precision-old/profile.nix
    ] ++ commonGraphicalHMModules;
  };

  "jacknystrom@wsl" = mkHomeManagerConfig {
    system = "x86_64-linux";
    imports = [
      ../hosts/wsl/profile.nix
    ] ++ wslModules;
  };
}

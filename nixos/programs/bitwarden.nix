{ pkgs, ... }: {
  # Note: bitwarden autostart is enabled in ../../home/programs/gui.nix
  # Moved from home/programs/gui.nix due to
  # https://github.com/nix-community/home-manager/issues/5559,
  # so bitwardens' polkit policy file is actually installed.
  # Note: ~/.mozilla must be created for bitwarden-desktop to be able to
  # install it's native-messaging-hosts file!
  environment.systemPackages = with pkgs; [
    # Password manager
    bitwarden-desktop
    bitwarden-cli
  ];

}

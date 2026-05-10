{ ... }: {
  # Miscellaneous configurations that all linux-desktop systems probably want.
  # Same as nixos/desktop.nix but for HM

  # Userland power notification daemon via upower. Replacement for the custom
  # shell scripting in nixos/hardware/power.nix.
  services.poweralertd.enable = true;
  services.poweralertd.extraArgs = [ "-s" "-S" ];

  dconf.settings = {
    "org/gnome/nm-applet" = {
      disable-connected-notifications = true;
      disable-disconnected-notifications = true;
      disable-vpn-notifications = false;
      suppress-wireless-networks-available = true;
    };
  };
}

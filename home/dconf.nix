{ ... }: {
  dconf.settings = {
    "org/gnome/nm-applet" = {
      disable-connected-notifications = true;
      disable-disconnected-notifications = true;
      disable-vpn-notifications = false;
      suppress-wireless-networks-available = true;
    };
  };
}

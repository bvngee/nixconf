{ lib, pkgs, config, ... }: {

  networking.hostName = config.host.hostname;
  networking.nameservers = [ "1.1.1.1" "8.8.8.8" ];

  networking.networkmanager.enable = true;
  # Gives my user permission to change network settings
  users.users.${config.host.mainUser}.extraGroups = [ "networkmanager" ];

  # resolved will use the dns servers set in `networking.nameservers`:
  # https://github.com/NixOS/nixpkgs/blob/7105ae3957700a9646cc4b766f5815b23ed0c682/nixos/modules/system/boot/resolved.nix#L18
  # This also automatically sets `networking.resolvconf.enable` to false
  services.resolved = {
    enable = true;
    # I'm not sure if I want this. Does it make dns slower? todo: do better testing or research
    # dnsovertls = "false";
  };

  # tbh not sure if this is useful lol. "Whether to enable resolved for stage 1 networking"
  # TODO(24.11): look into this maybe?
  # boot.initrd.services.resolved.enable = true;

  # Provides a tray UI to manager networks, and is also a Network Manager Secret
  # Agent (i.e. network manager should use nm-applet to ask for passwords).
  # This is only useable thanks to the disabled notifications via dconf settings
  # in home/dconf.nix.
  programs.nm-applet = {
    enable = true;
    indicator = true;
  };

  # Hardcoded NetworkManager configurations. First created manually in nmtui (or other tools),
  # then converted to nix code via https://github.com/janik-haag/nm2nix. These exist alongside
  # the imperatively created networks.
  # Config spec: https://networkmanager.dev/docs/api/latest/nm-settings-nmcli.html
  networking.networkmanager.ensureProfiles.profiles =
    let
      mkEduroamProfile = ssid: {
        wifi = {
          inherit ssid;
          mode = "infrastructure";
        };
        "802-1x" = {
          # Can be omitted, but that allows MITM attacks.
          ca-cert = "${pkgs.fetchurl { 
            url = "https://drive.usercontent.google.com/download?id=15MIbkLNMgJZPSQVxelrq9fn3BVD8OlSC&confirm=xxx";
            hash = "sha256-XrH90kYbm+QpqMrAROtmHcJDUF+6TIm3DWoYF14Jydc="; 
            name = "ca.crt";
          }}";
          anonymous-identity = "anon";
          domain-suffix-match = "ucsc.edu";
          eap = "peap;";
          identity = "jnystrom@ucsc.edu";
          # Password is agent-owned. NM will query a secret agent program for
          # the password, i.e. nm-applet (https://networkmanager.dev/docs/libnm/latest/NMSetting.html#NMSettingSecretFlags)
          password-flags = 1; 
          phase2-auth = "mschapv2";
        };
        connection = {
          id = "${ssid} (nixconf)";
          type = "wifi";
          autoconnect = true;
          autoconnect-priority = "30";
        };
        wifi-security = {
          auth-alg = "open";
          key-mgmt = "wpa-eap";
        };
        proxy = { };
      };
    in
    {
      "Eduroam (nixconf)" = lib.mkIf (config.host.isMobile) (mkEduroamProfile "eduroam");
      "ResWiFi (nixconf)" = lib.mkIf (config.host.isMobile) (mkEduroamProfile "ResWiFi");
    };

  # Configures wpa_supplicant directly; mostly incompatible with the above networkingmanager
  # profiles (unless you make nm give up ownership of the entire wireless interface)
  # networking.wireless.networks = { };
}

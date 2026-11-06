{ pkgs, lib, ... }: {
  services.pulseaudio.enable = lib.mkForce false;
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    jack.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    wireplumber.enable = true;

    extraConfig.pipewire-pulse = {
      # This seems to be necessary for automatic device switching in some cases
      "20-switch-on-connect" = {
        "pulse.cmd" = [
          { cmd = "load-module"; args = "module-switch-on-connect"; }
        ];
      };
    };

    # TODO: I want software EQs but this is way too annoying to change. What GUI
    # to use?
    extraConfig.pipewire = {
      # EQ profiles
      "99-eq-profiles" =
        let
          z313DeskSpeakers = pkgs.writeText "Logitech_z313.txt" ''
            Preamp: 7.0 dB
            Filter 1: ON PK Fc 20 Hz Gain -2.0 dB Q 1.0
            Filter 2: ON PK Fc 57 Hz Gain -10.3 dB Q 1.5
            Filter 3: ON PK Fc 90 Hz Gain -3.9 dB Q 2.0
            Filter 4: ON PK Fc 155 Hz Gain -13.1 dB Q 0.7
            Filter 5: ON PK Fc 218 Hz Gain -1.8 dB Q 3.2
            Filter 5: ON PK Fc 265 Hz Gain -3.2 dB Q 4.0
            Filter 6: ON PK Fc 349 Hz Gain 4.9 dB Q 4.0
            Filter 7: ON PK Fc 360 Hz Gain -5.9 dB Q 2.6
            Filter 8: ON PK Fc 444 Hz Gain 4.9 dB Q 2.0
            Filter 9: ON PK Fc 690 Hz Gain 1.9 dB Q 2.0
            Filter 10: ON PK Fc 860 Hz Gain -1.8 dB Q 3.0
            Filter 11: ON PK Fc 1500 Hz Gain -1.5 dB Q 2.0
            Filter 12: ON PK Fc 2500 Hz Gain -4.7 dB Q 0.3
            Filter 13: ON PK Fc 7000 Hz Gain -10.8 dB Q 0.2
            Filter 14: ON PK Fc 12160 Hz Gain -7.0 dB Q 7.0
            Filter 15: ON PK Fc 13460 Hz Gain -5.5 dB Q 7.0
            Filter 16: ON PK Fc 14500 Hz Gain -8.3 dB Q 7.0
            Filter 17: ON PK Fc 19900 Hz Gain -12.3 dB Q 5.0
          '';
          HD6XXHeadphones = pkgs.writeText "Sennheiser_HD_6XX.txt" ''
            Preamp: -6.1 dB
            Filter 1: ON LSC Fc 105 Hz Gain 6.4 dB Q 0.70
            Filter 2: ON PK Fc 8800 Hz Gain 5.1 dB Q 1.42
            Filter 3: ON PK Fc 118 Hz Gain -3.1 dB Q 0.50
            Filter 4: ON PK Fc 37 Hz Gain 0.7 dB Q 3.96
            Filter 5: ON PK Fc 3169 Hz Gain -1.7 dB Q 3.89
            Filter 6: ON HSC Fc 10000 Hz Gain -2.1 dB Q 0.70
            Filter 7: ON PK Fc 1227 Hz Gain -1.2 dB Q 2.53
            Filter 8: ON PK Fc 2055 Hz Gain 1.2 dB Q 3.23
            Filter 9: ON PK Fc 587 Hz Gain 0.4 dB Q 1.19
            Filter 10: ON PK Fc 5332 Hz Gain -1.1 dB Q 5.75
          '';
        in
        {
          "context.modules" = [
            {
              name = "libpipewire-module-parametric-equalizer";
              args = {
                "equalizer.filepath" = z313DeskSpeakers;
                "equalizer.description" = "Logitech Z313 Parametric EQ Sink";
                "audio.channels" = 2;
                "audio.position" = [ "FL" "FR" ];
              };
            }
            {
              name = "libpipewire-module-parametric-equalizer";
              args = {
                "equalizer.filepath" = HD6XXHeadphones;
                "equalizer.description" = "Sennheiser HD 6XX Parametric EQ Sink";
                "audio.channels" = 2;
                "audio.position" = [ "FL" "FR" ];
              };
            }
          ];
        };
    };
  };

  programs.noisetorch.enable = true;

  ### pipewireLowLatency ### solen from:
  ### https://github.com/fufexan/nix-gaming/blob/master/modules/pipewireLowLatency.nix
  imports = [
    ({ pkgs, ... }:
      let
        quantum = 64;
        rate = 48000;
        qr = "${toString quantum}/${toString rate}";
      in
      {
        services.pipewire = {
          # make sure PipeWire is enabled if the module is imported
          # and low latency is enabled
          enable = true;

          # write extra config
          extraConfig = {
            pipewire."99-lowlatency" = {
              "context.properties"."default.clock.min-quantum" = quantum;

              "context.modules" = [
                {
                  name = "libpipewire-module-rt";
                  flags = [
                    "ifexists"
                    "nofail"
                  ];
                  args = {
                    "nice.level" = -15;
                    "rt.prio" = 88;
                    "rt.time.soft" = 200000;
                    "rt.time.hard" = 200000;
                  };
                }
              ];
            };

            pipewire-pulse."99-lowlatency"."pulse.properties" = {
              "server.address" = [ "unix:native" ];
              "pulse.min.req" = qr;
              "pulse.min.quantum" = qr;
              "pulse.min.frag" = qr;
            };

            client."99-lowlatency"."stream.properties" = {
              "node.latency" = qr;
              "resample.quality" = 1;
            };
          };

          # ensure WirePlumber is enabled explicitly
          # and write extra config to ship low latency rules for alsa
          wireplumber = {
            enable = true;
            extraConfig = {
              "99-alsa-lowlatency"."monitor.alsa.rules" = [
                {
                  matches = [{ "node.name" = "~alsa_output.*"; }];
                  actions.update-props = {
                    "audio.format" = "S32LE";
                    "audio.rate" = rate;
                  };
                }
              ];
            };
          };
        };
      }
    )
  ];
}

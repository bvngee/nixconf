{ lib, ... }: {
  services.pulseaudio.enable = lib.mkForce false;
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    jack.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    wireplumber.enable = true;

    # This seems to be necessary for automatic device switching in some cases
    extraConfig.pipewire-pulse = {
      "20-switch-on-connect" = {
        "pulse.cmd" = [
          { cmd = "load-module"; args = "module-switch-on-connect"; }
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

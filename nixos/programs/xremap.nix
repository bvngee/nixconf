{ pkgs, config, inputs, ... }: {
    imports = [
        # The xremap flake gives us the systemd service nixos module. We use the
        # xremap package from nixpkgs though to skip building from source
        inputs.xremap-flake.nixosModules.default
    ];
    services.xremap = {
        package = pkgs.xremap;
        enable = true;

        # Note: without any `withCompositor` feature flags enabled, no
        # per-application remap support exists

        # My Logitech MX Vertical is weird and creates multiple keyboard uinput
        # devices and when xremap claims them it also claims the corresponding
        # mouse input device which prevents Hyprland from changing its
        # sensitivity directly.
        extraArgs = [ "--ignore 'MX Vertical'" ];

        watch = true;
        userName = config.host.mainUser;
        serviceMode = "system";
        config = {
            modmap = [
                {
                    name = "CapsLock Remaps";
                    remap = {
                        "CapsLock" = "Esc";
#                        "CapsLock" = {
#                            held = "LeftCtrl";
#                            alone = "Esc";
#                            alone_timout_millis = 100;
#                        };
                    };
                }
            ];
        };
    };
}

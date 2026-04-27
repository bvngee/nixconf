{ pkgs, ... }: {
  hardware = {
    graphics = {
      enable = true;

      # Honestly I'm not sure if this library is hardware specific or not...
      # https://github.com/intel/libva
      extraPackages = with pkgs; [ libva ];
      extraPackages32 = with pkgs.pkgsi686Linux; [ libva ];
    };
  };

  environment.systemPackages = with pkgs; [
    # not sure if these are necessary at all; stolen from the nvidia section of sioodmy's dotfiles
    vulkan-loader
    vulkan-validation-layers
    vulkan-extension-layer
    vulkan-tools

    # probably useful for debugging
    mesa-demos
    vdpauinfo
    libva-utils
  ];

}

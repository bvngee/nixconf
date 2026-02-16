{ inputs, pkgs, ... }: {
  boot = {
    # Kernel version and package set.
    kernelPackages =
      let
        # I use a separate, dedicated nixpkgs input for this because I _hate_ recompiling
        # the kernel and nvidia drivers every time I update pkgsUnstable.
        pkgsKernelPackages = import inputs.nixpkgs-kernel-packages {
          inherit (pkgs.stdenv.hostPlatform) system;
          config.allowUnfree = true; # proprietary nvidia drivers
        };
      in
      # note: using a non-standard kernel requires compiling kernel modules
      # (like nvidia drivers) from source, as the kernel is one their inputs.
      # However this isn't that big of a problem as I rarely update the version
      # of nixpkgs-kernel-packages.
      pkgsKernelPackages.linuxPackages_xanmod; # alias to pkgs.linuxKernel.packages.linux_xanmod

    # Any extra kernel modules go here
    extraModulePackages = [ ]; #with config.boot.kernelPackages; 
    kernelModules = [ ];
  };
}

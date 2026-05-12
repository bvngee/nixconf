# Custom configuration for Dell Precision laptop
# See: www.delltechnologies.com/asset/en-ie/products/workstations/technical-support/precision-5490-spec-sheet.pdf
{ pkgs, pkgsUnstable, ... }: {
  imports = [
    ./hardware-configuration.nix
    ./nvidia.nix
  ];

  boot.kernelParams = [
    # Experiment: try new intel igpu driver. TODO: when update to newer kernel, try this again!!
    # "i915.force_probe=!7d55"
    # "xe.force_probe=7d55"
  ];

  hardware.graphics.extraPackages = [ pkgs.intel-media-driver ];
  hardware.graphics.extraPackages32 = [ pkgs.pkgsi686Linux.intel-media-driver ];

  # Hack: Use updated Mesa, for update intel gpu driver. This fixes the
  # "FINISHME: support more multi-planar formats with DRM modifiers" and related
  # errors. TODO(26.05)
  system.replaceRuntimeDependencies = [
    ({ original = pkgs.mesa; replacement = pkgsUnstable.mesa; })
  ];
  # Hack: Vulkan apps (Gtk3's OpenGL components, and all Gtk4 apps) love to
  # choose the discrete GPU thanks to Nvidia drivers. On PRIME systems, it takes
  # literally 2+ seconds for every app startup because it has to wake the GPU
  # (possibly nvidia driver bug also), and we don't want that anyway because 
  # it's bad for performance. I could not for the life of me figure out
  # another environment variable that Gtk respects to change the GPU priority,
  # so we must resort to globally disabling vulkan for GTK (other vulkan apps
  # will still use the dGPU).
  # https://gitlab.gnome.org/GNOME/gtk/-/work_items/6689
  environment.sessionVariables.GSK_RENDERER = "gl";
  # Alternatively, we could forcefully limit the Vulkan driver selection for all
  # apps:
  #environment.sessionVariables.VK_ICD_FILENAMES = "${pkgs.mesa}/share/vulkan/icd.d/intel_icd.x86_64.json";

  # To enroll: `fprintd-enroll`
  services.fprintd.enable = true;

  system.stateVersion = "25.11";
}

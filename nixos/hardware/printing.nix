{ pkgs, ... }: {
  services.printing.enable = true;
  services.avahi.enable = true;
  services.avahi.nssmdns4 = true;
  services.avahi.openFirewall = true;
  services.system-config-printer.enable = true;
  programs.system-config-printer.enable = true;

  environment.systemPackages = with pkgs; [
    cups-filters 
  ];
}

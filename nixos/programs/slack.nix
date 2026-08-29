{ pkgs, ... }: {
  # Adding to home-manager didn't work for slack:// magic urls (required for sign in)
  environment.systemPackages = [
    pkgs.slack
  ];
}

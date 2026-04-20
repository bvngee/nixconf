{ inputs, ... }: {
  # Common system-wide nixpkgs configurations
  config = {
    nixpkgs = {
      overlays = [
        # Adds the default `pkgs.nur` overlay to nixpkgs
        inputs.nur.overlays.default
      ];
      config = {
        allowUnfree = true;
        allowUnfreePredicate = _: true;
      };
    };
  };
}

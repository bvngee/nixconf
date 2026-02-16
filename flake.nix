{
  description = "Bvngee's personal NixOS system and home configurations";

  outputs = { self, nixpkgs, ... }@inputs: {

    nixosConfigurations = import ./configs/nixos-configs.nix { inherit self nixpkgs inputs; };

    homeConfigurations = import ./configs/home-configs.nix { inherit self nixpkgs inputs; };

    packages =
      let
        # I've only tested the below packages on x86_64-linux, so I'll only
        # export them for that system. Eventually I may switch to forEachSystem.
        system = "x86_64-linux";
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        ${system} = {
          mow = pkgs.callPackage ./pkgs/mow {};

          ix_usb_can = pkgs.linuxPackages.callPackage ./pkgs/ix_usb_can {};

          supercan_usb = pkgs.linuxPackages.callPackage ./pkgs/supercan_usb {};
        };
      };

  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # Extremely temporary; pending nvim config update
    nixpkgs-neovim.url = "github:nixos/nixpkgs/cd5f33f23db0a57624a891ca74ea02e87ada2564";

    # sometimes I want to update nnixpkgs-unstable without recompiling linux_xanmod and
    # nvidia drivers. When I do feel like it, I can fast-forward this
    nixpkgs-kernel-packages.url = "github:nixos/nixpkgs/nixos-25.11";

    # nix-index, but with a prebuilt database (and convenient hm/nixos modules)
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Used for the nixos module's xremap systemd service only. Package is used from nixpkgs
    xremap-flake = {
      url = "github:xremap/nix-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    base16.url = "github:SenchoPens/base16.nix";
  };
}

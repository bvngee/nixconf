{ config, pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    # not sure if I really need these?
    podman-compose

    # basically a docker/podman wrapper that simplifies making tightly-integrated linux containers
    # NOTE(https://github.com/89luca89/distrobox/issues/1229):
    # put "skip_workdir=1" in ~/.config/distrobox/distrobox.conf
    distrobox

    # lets you explore docker container layers
    dive

    # useful for things like moving images between registries and other locations or 
    # inspecting images without downloading
    skopeo # note: nix2container contains a patched version with support for a "nix:" source type

    # nice wine/proton wrapper using gtk4 (alternative is lutris)
    # Im putting bottles here aswell as vms.nix because sometimes I want to play
    # with exe's on my weak laptop
    bottles
  ];

  virtualisation = {
    docker = {
      enable = true;
      # NOTE: To reclaim a ton of disk space from unused build/image cache that
      # `docker rmi` doesn't get (for me it was in `/var/lib/docker/containerd/daemon`),
      # use `docker system prune`!! 
      daemon.settings = {
        features = {
          # This makes docker use containerd's image store instead of it's own,
          # which supports multiarch images (among other things).
          # https://docs.docker.com/build/building/multi-platform/#enable-the-containerd-image-store
          # https://github.com/docker/roadmap/issues/371
          "containerd-snapshotter" = true;
        };
      };
    };
    podman = {
      enable = true;
      # not sure that I want these yet... podman has some differences that might get annoying
      # if it fully replaces docker (especially since I dont have that much experience with docker yet)
      dockerCompat = false;
      dockerSocket.enable = false;

      defaultNetwork.settings.dns_enabled = true;
    };
  };

  # replaces [docker/podman].enableNvidia
  hardware.nvidia-container-toolkit.enable = config.host.isNvidia;

  users.users.${config.host.mainUser}.extraGroups = [ "docker" ];
}

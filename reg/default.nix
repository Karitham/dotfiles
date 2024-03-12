{
  pkgs,
  ssh-keys,
  ...
}: {
  nix.settings = {
    trusted-users = ["root" "kar"];
    experimental-features = ["nix-command" "flakes"];
    auto-optimise-store = true;
  };
  imports = [./hardware.nix ./services.nix];

  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = true;
  networking.hostName = "reg";

  services = {
    tailscale.enable = true;
    tailscale.useRoutingFeatures = "server";
    openssh.enable = true;
  };

  nixpkgs = {
    hostPlatform = "x86_64-linux";
    config = {allowUnfree = true;};
  };

  users.users = {
    root.openssh.authorizedKeys.keyFiles = [ssh-keys];
    kar = {
      isNormalUser = true;
      extraGroups = ["wheel" "docker"];
      home = "/home/kar";
      openssh.authorizedKeys.keyFiles = [ssh-keys];
    };
  };

  security.sudo.wheelNeedsPassword = false;

  virtualisation.docker.enable = true;
  environment.systemPackages = with pkgs; [
    tailscale
    helix
    docker
    curl
    wget
    jq
  ];

  programs.bash.shellInit = ''
    export HISTCONTROL=ignoreboth:erasedups
  '';

  virtualisation.oci-containers.backend = "docker";
  virtualisation.oci-containers.containers = {
    tclip = {
      image = "ghcr.io/tailscale-dev/tclip";
      volumes = ["/var/lib/tclip:/data"];
      environment = {
        DATA_DIR = "/data";
        TS_AUTHKEY = "tskey-auth-k3qZTN7CNTRL-qMqFYJztQq8M4n2NVbcWq8Ch9qcwHdCUM";
      };
    };
  };

  system = {stateVersion = "23.05";};
}

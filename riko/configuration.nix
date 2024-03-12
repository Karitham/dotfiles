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
  boot.loader.efi.canTouchEfiVariables = true;
  networking.useDHCP = true;

  networking.hostName = "riko";
  users.defaultUserShell = pkgs.zsh;
  users.users = {
    root.openssh.authorizedKeys.keyFiles = [ssh-keys];
    kar = {
      isNormalUser = true;
      extraGroups = ["wheel"];
      home = "/home/kar";
      openssh.authorizedKeys.keyFiles = [ssh-keys];
    };
  };

  security.sudo.wheelNeedsPassword = false;

  services = {
    tailscale.enable = true;
    tailscale.useRoutingFeatures = "server";
    openssh.enable = true;
  };

  environment.systemPackages = with pkgs; [
    busybox
    zsh
    tailscale
    helix
    curl
    wget
    jq
    git
    direnv
  ];

  programs.zsh = {
    enable = true;
    shellAliases = {
      ll = "ls -l";
      update = "sudo nixos-rebuild switch --flake /home/kar/nix-config#riko";
    };
    ohMyZsh = {
      plugins = ["direnv"];
    };
    shellInit = ''eval "$(direnv hook zsh)"'';
  };

  system = {stateVersion = "23.05";};
}

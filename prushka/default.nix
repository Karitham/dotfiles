{
  pkgs,
  ssh-keys,
  ...
}: {
  imports = [
    ./hardware.nix
    ../common/seedbox.nix
  ];

  services.rtorrent.downloadDir = "/media/downloads";

  nix.settings = {
    trusted-users = ["root"];
    experimental-features = ["nix-command" "flakes"];
    auto-optimise-store = true;
  };

  networking.hostName = "prushka";

  services = {
    tailscale.enable = true;
    tailscale.useRoutingFeatures = "server";
    tailscale.extraUpFlags = ["--ssh" "--advertise-exit-node"];
    openssh.enable = true;
  };
  users.users.root.openssh.authorizedKeys.keyFiles = [ssh-keys];

  environment.systemPackages = with pkgs; [
    busybox
    tailscale
    helix
    curl
    git
  ];

  system = {stateVersion = "23.05";};
}

{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
    ../common/seedbox.nix
  ];

  nix.settings = {
    experimental-features = ["nix-command" "flakes"];
    auto-optimise-store = true;
  };
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 1w";
  };
  # Allow unfree packages
  nixpkgs.config = {
    allowUnfree = true;
    input-fonts.acceptLicense = true;
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = ["bcachefs"];
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "faputa"; # Define your hostname.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  time.timeZone = "Europe/Paris";
  services.openssh.enable = true;
  services.tailscale.extraUpFlags = ["--ssh"];
  services.tailscale.enable = true;
  environment.systemPackages = with pkgs; [
    helix
    git
    tailscale
  ];

  system.stateVersion = "23.11"; # Did you read the comment?
}

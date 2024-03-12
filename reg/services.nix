{...}: {
  virtualisation.docker.enable = true;
  users.extraUsers.kar.extraGroups = ["docker"];

  services.nginx.enable = true;
  security.acme = {
    acceptTerms = true;
    defaults.email = "kar@karitham.dev";
  };

  networking.firewall.allowedTCPPorts = [80 443];

  imports = [
    ./services/waifubot.nix
  ];
}

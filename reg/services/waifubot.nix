{
  config,
  pkgs,
  ...
}: {
  age.secrets."waifubot.env".file = ../../secrets/waifubot.env.age;
  age.identityPaths = ["/root/.ssh/k_ed25519"];

  systemd.services.waifubot = let
    deployment = pkgs.arion.build {
      modules = [
        ({...}: {
          project.name = "waifubot";
          services = {
            waifubot = {
              service = {
                container_name = "waifubot";
                image = "ghcr.io/karitham/waifubot:corde";
                env_file = ["${config.age.secrets."waifubot.env".path}"];
                ports = ["53245:8080"];
              };
            };
          };
        })
      ];
    };
  in {
    enable = true;
    serviceConfig = {
      ExecStart = "${pkgs.docker}/bin/docker compose -f ${deployment} up";
      Restart = "always";
    };
    wantedBy = ["multi-user.target"];
    after = ["docker.service"];
  };

  services.nginx.virtualHosts = {
    "waifubot.0xf.fr" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {proxyPass = "http://127.0.0.1:53245";};
    };
  };
}

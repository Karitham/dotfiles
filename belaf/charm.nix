{pkgs, ...}: {
  environment.sessionVariables = {
    CHARM_HOST = "localhost";
  };
  systemd.services.charm = {
    enable = true;
    serviceConfig = {
      ExecStartPre = "-${pkgs.coreutils}/bin/mkdir -p /var/lib/charm/data";
      ExecStart = "${pkgs.charm}/bin/charm serve";
      Restart = "always";
      Environment = "CHARM_SERVER_DATA_DIR=/var/lib/charm/data";
    };
    wantedBy = ["multi-user.target"];
  };
}

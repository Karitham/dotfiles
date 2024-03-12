{
  config,
  pkgs,
  ...
}: {
  age.secrets."kraud.conf".file = ../secrets/kraud.conf.age;
  age.identityPaths = ["${config.users.users.kar.home}/.ssh/id_ed25519"];
  environment.systemPackages = with pkgs; [wireguard-tools];
  networking.wg-quick.interfaces.kraud = {
    configFile = "${config.age.secrets."kraud.conf".path}";
  };
}

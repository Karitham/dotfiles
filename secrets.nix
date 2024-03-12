let
  keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIArfkAOX//Z8j7s2/9TfFLPN7Rikzpxz85NXUf2W+nL6"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPp5PrnHTc6lsLIj/2FKB4/MUnkupIz+RSHVNnAplbGn"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIO2N3EOzzFcWuUfyR1BcLkrbyZ7YFgeiS1vcGQlXE7F"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL2QytRwI6LrtVzALHdcIbyuAJWpsH2ghKB5JxbjoBaQ"
  ];
in {
  "secrets/kraud.conf.age".publicKeys = keys;
  "secrets/waifubot.env.age".publicKeys = keys;
}

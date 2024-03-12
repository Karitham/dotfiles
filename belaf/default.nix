{
  hyprland,
  agenix,
  home-manager,
  ...
}: {
  imports = [
    ./hardware.nix
    ./desktop.nix
    ./configuration.nix
    ./fabric.nix
    ./wga.nix
    home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.kar = ./home;
    }
    hyprland.nixosModules.default
    {programs.hyprland.enable = true;}
    agenix.nixosModules.default
    ./greetd.nix
    ./charm.nix
  ];
}

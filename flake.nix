{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    ghostty.url = "git+ssh://git@github.com/mitchellh/ghostty";
    hyprland.url = "github:hyprwm/Hyprland";
    hyprland.inputs.nixpkgs.follows = "nixpkgs";
    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    ssh-keys = {
      url = "https://github.com/karitham.keys";
      flake = false;
    };
  };
  outputs = {
    nixpkgs,
    home-manager,
    ghostty,
    hyprland,
    ssh-keys,
    agenix,
    ...
  } @ inputs: rec {
    forAllSystems = nixpkgs.lib.genAttrs [
      "aarch64-linux"
      "i686-linux"
      "x86_64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ];

    defaultPackage."x86_64-linux" = home-manager.defaultPackage."x86_64-linux";
    homeConfigurations = {
      kar = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {system = "x86_64-linux";};
        modules = [./belaf/home.nix];
      };
    };

    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#'
    nixosConfigurations = {
      belaf = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        specialArgs = {
          inherit inputs;
          home-manager = home-manager;
          ghostty = ghostty;
          hyprland = hyprland;
          agenix = agenix;
        };

        modules = [./belaf];
      };

      riko = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";

        specialArgs = {
          inherit inputs;
          ssh-keys = ssh-keys;
        };

        modules = [agenix.nixosModules.default ./riko];
      };

      reg = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        specialArgs = {
          inherit inputs;
          ssh-keys = ssh-keys;
        };

        modules = [agenix.nixosModules.default ./reg];
      };

      faputa = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
          ssh-keys = ssh-keys;
        };

        modules = [./faputa];
      };

      prushka = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
          ssh-keys = ssh-keys;
        };

        modules = [./prushka];
      };
    };

    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);
  };
  nixConfig = {
    extra-substituters = ["https://hyprland.cachix.org" "https://ghostty.cachix.org"];
    extra-trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" "ghostty.cachix.org-1:QB389yTa6gTyneehvqG58y0WnHjQOqgnA+wBnpWWxns="];
    extra-experimental-features = ["nix-command" "flakes"];
  };
}

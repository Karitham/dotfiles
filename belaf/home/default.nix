{...}: {
  programs.home-manager.enable = true;
  home.username = "kar";
  home.homeDirectory = "/home/kar";
  home.stateVersion = "23.11";

  xdg.mimeApps = {
    enable = true;
    associations.added = {
      "x-scheme-handler/http" = ["chromium.desktop"];
      "x-scheme-handler/https" = ["chromium.desktop"];
    };
    defaultApplications = {
      "x-scheme-handler/http" = ["chromium.desktop"];
      "x-scheme-handler/https" = ["chromium.desktop"];
    };
  };

  imports = [
    ./hyprland.nix
    ./waybar.nix
    ./dunst.nix
    ./helix.nix
    ./rofi.nix
  ];

  xdg.configFile = {
    "ghostty/config".source = ./dotfiles/ghostty;
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableAutosuggestions = true;
    syntaxHighlighting.enable = true;
  };

  programs.starship.enable = true;
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;
  programs.direnv.stdlib = ''
    alias() {
      mkdir -p .direnv/bin
      echo "#!/usr/bin/env sh
      $(which $2) \$@" >.direnv/bin/$1
      chmod +x .direnv/bin/$1
    }
  '';
}

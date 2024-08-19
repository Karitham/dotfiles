{...}: {
  programs = {
    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      shellAliases = {
        gs = "git status";
        ls = "eza --git";
        update = "sudo nixos-rebuild switch --accept-flake-config --flake";
        k = "kubectl";
        kall = "kubectl get $(kubectl api-resources --namespaced=true --no-headers -o name | egrep -v 'events|nodes' | paste -s -d, - ) --no-headers";
      };
    };

    atuin.enable = true;
    atuin.flags = [
      "--disable-up-arrow"
    ];
    atuin.settings = {
      enter_accept = false;
      style = "compact";
    };

    starship.enable = true;
    starship.settings = {
      kubernetes = {
        disabled = false;
      };
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
      stdlib = ''
        alias() {
          mkdir -p .direnv/bin
          echo "#!/usr/bin/env sh
          $(which $2) \$@" >.direnv/bin/$1
          chmod +x .direnv/bin/$1
        }
        use_wg() {
          if [[ $1 ]] ; then
            wg-quick up $1
          else
            wg-quick up ./*.conf
          fi
        }
      '';
    };
  };
}
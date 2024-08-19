{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.programs.ghostty;

  eitherStrBoolInt = with types; either str (either bool int);

  toGhosttyConfig = generators.toKeyValue rec {
    mkKeyValue = key: value:
      if builtins.isAttrs value
      then concatStringsSep "\n" (mapAttrsToList (subKey: subValue: "${key}=${mkKeyValue subKey subValue}") value)
      else if builtins.isBool value
      then "${key}=${boolToString value}"
      else "${key}=${toString value}";
  };
in {
  options.programs.ghostty = {
    enable = mkEnableOption "Ghostty terminal emulator";

    package = mkOption {
      type = types.package;
      defaultText = literalExpression "ghostty.packages.\"${system}\".default";
      description = ''
        Ghostty package to install, required.
      '';
    };

    settings = mkOption {
      type = types.attrsOf (
        types.either (types.attrsOf eitherStrBoolInt) eitherStrBoolInt
      );
      default = {};
      example = literalExpression ''
        {
          font-family = "Fira Code Nerd Font";
          background = "#282c34";
          scrollback-limit = 10000000;
          palette = {
            "0" = "#24273a";
            "1" = "#ed8796";
            "2" = "#a6da95";
          };
          keybind = {
            "ctrl+comma" = "open_config";
            "ctrl+shift+q" = "quit";
          };
        }
      '';
      description = ''
        Configuration written to
        {file}`$XDG_CONFIG_HOME/ghostty/config`. See
        <https://github.com/ghostty-org/ghostty/blob/main/src/config/Config.zig>
        for the documentation.
      '';
    };

    extraConfig = mkOption {
      default = "";
      type = types.lines;
      description = "Additional configuration to add.";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [cfg.package];

    xdg.configFile."ghostty/config" = {
      text = concatStringsSep "\n" [
        ''
          # Generated by Home Manager.
          # See https://github.com/ghostty-org/ghostty/blob/main/src/config/Config.zig
        ''
        (toGhosttyConfig cfg.settings)
        cfg.extraConfig
      ];
    };
  };
}

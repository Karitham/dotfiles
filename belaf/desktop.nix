{pkgs, ...}: {
  services.upower.enable = true;
  environment = with pkgs; {
    sessionVariables = {};
    systemPackages = [
      dolphin
      wl-clipboard
      waybar
      wlroots
      grim
      slurp
      dunst
      xdg-utils
      xdg-desktop-portal-hyprland
      pavucontrol
      killall
      playerctl
      brightnessctl
      upower
      pulseaudio
      gnome-themes-extra
    ];
  };
}

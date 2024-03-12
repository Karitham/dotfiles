{...}: {
  services.dunst.enable = true;
  services.dunst.settings = {
    global = {
      width = 300;
      height = 300;
      offset = "30x50";
      origin = "top-right";
      transparency = 10;
      frame_color = "#8AADF4";
      separator_color = "frame";
    };

    urgency_low = {
      background = "#24273A";
      foreground = "#CAD3F5";
    };

    urgency_normal = {
      background = "#24273A";
      foreground = "#CAD3F5";
    };

    urgency_critical = {
      background = "#24273A";
      foreground = "#CAD3F5";
      frame_color = "#F5A97F";
    };
  };
}

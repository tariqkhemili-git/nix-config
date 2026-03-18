{ ... }:

{
  wayland.windowManager.hyprland.settings = {
    workspace = [
      # Monitor Bindings (180Hz DP-3 & 200Hz HDMI-A-1)
      "1, monitor:DP-3, default:true"
      "2, monitor:HDMI-A-1, default:true"

      # Special scratchpad for Equibop (Discord)
      "special:equibop, on-created-empty:equibop, gapsin:15, gapsout:30"
      # Special scratchpad for Spotify (Music)
      "special:spotify, gapsin:15, gapsout:30"
    ];
  };
}

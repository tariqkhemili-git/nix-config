{ ... }:

{
  wayland.windowManager.hyprland.enable = true;
  wayland.windowManager.hyprland.settings = {
    general = {
      gaps_in = 5;
      gaps_out = 20;
      border_size = 2;

      # Accent colour #87b2d4 with a darker slate/blue-grey gradient
      "col.active_border" = "rgb(87b2d4) rgb(4a657c) 45deg";
      # Dark grey-blue for inactive borders
      "col.inactive_border" = "rgba(1e293baa)";

      # QoL: Allows resizing by clicking and dragging on borders/gaps
      resize_on_border = true;
      extend_border_grab_area = 15;

      allow_tearing = false;
      layout = "dwindle";
    };

    decoration = {
      rounding = 10;
      rounding_power = 2;

      active_opacity = 1.0;
      inactive_opacity = 0.95; # Slight transparency for background windows

      # Dims inactive windows slightly to make the accent colour pop
      dim_inactive = true;
      dim_strength = 0.1;

      shadow = {
        enabled = true;
        range = 15; # Softer, wider drop shadow
        render_power = 3;
        # Deep dark blue-black shadow to match the slate theme
        color = "rgba(0a0f14ee)";
      };

      blur = {
        enabled = true;
        size = 3;
        passes = 2; # Increased passes for a smoother, premium glass effect
        vibrancy = 0.2;
        vibrancy_darkness = 0.5; # Better blending in dark environments
      };
    };

    animations = {
      enabled = true;
      bezier = [
        "easeOutQuint, 0.23, 1, 0.32, 1"
        "easeInOutCubic, 0.65, 0.05, 0.36, 1"
        "linear, 0, 0, 1, 1"
        "almostLinear, 0.5, 0.5, 0.75, 1"
        "quick, 0.15, 0, 0.1, 1"
      ];
      animation = [
        "global, 1, 10, default"
        "border, 1, 5.39, easeOutQuint"
        "windows, 1, 4.79, easeOutQuint"
        "windowsIn, 1, 4.1, easeOutQuint, popin 87%"
        "windowsOut, 1, 1.49, linear, popin 87%"
        "fadeIn, 1, 1.73, almostLinear"
        "fadeOut, 1, 1.46, almostLinear"
        "fade, 1, 3.03, quick"
        "layers, 1, 3.81, easeOutQuint"
        "layersIn, 1, 4, easeOutQuint, fade"
        "layersOut, 1, 1.5, linear, fade"
        "fadeLayersIn, 1, 1.79, almostLinear"
        "fadeLayersOut, 1, 1.39, almostLinear"
        "workspaces, 1, 1.94, almostLinear, fade"
        "workspacesIn, 1, 1.21, almostLinear, fade"
        "workspacesOut, 1, 1.94, almostLinear, fade"
        "zoomFactor, 1, 7, quick"
        "specialWorkspace, 1, 5, easeOutQuint, slidevert"
      ];
    };

    dwindle = {
      pseudotile = true;
      preserve_split = true;
    };

    master = {
      new_status = "master";
    };

    misc = {
      force_default_wallpaper = -1;
      disable_hyprland_logo = true; # Keeps the background completely clean

      # Hardware optimisation: drops refresh rate when the screen is static
      vfr = true;
      animate_manual_resizes = true;
    };

    input = {
      kb_layout = "gb"; # UK keyboard layout preserved
      follow_mouse = 1;
      sensitivity = 0;
      touchpad = {
        natural_scroll = false;
      };
    };

    # gestures = {
    #   workspace_swipe = true;
    # };

    device = {
      name = "epic-mouse-v1";
      sensitivity = -0.5;
    };
  };
}

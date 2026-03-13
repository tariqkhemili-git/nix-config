{ pkgs, ... }:

{
  wayland.windowManager.hyprland.settings = {
    exec-once = [
      # --- System Essentials ---
      "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
      "systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
      "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"

      # --- UI & Rice Elements ---
      "waybar"
      "swaync"
      # "nm-applet --indicator" # Fixed the line break here

      "wl-paste --type text --watch cliphist store"
      "wl-paste --type image --watch cliphist store"

      # --- Wallpaper Engine ---
      "linux-wallpaperengine --silent --scaling fill --fps 60 --screen-root DP-3 --bg 3341326865 --screen-root HDMI-A-1 --bg 3449595825 --set-property newproperty3=\"0.52 0.69 0.83\""

      # --- Privacy & Sync Services ---
      "equibop"
    ];
  };
}

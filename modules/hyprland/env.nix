{ ... }:

{
  home.sessionVariables = {
    # Cursor Settings
    XCURSOR_SIZE = "24";
    XCURSOR_THEME = "Bibata-Modern-Classic";
    HYPRCURSOR_SIZE = "24";

    # Nvidia Specific Compatibility
    LIBVA_DRIVER_NAME = "nvidia";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    GBM_BACKEND = "nvidia-drm";
    NVD_BACKEND = "direct";

    # Toolkits & Wayland Support
    NIXOS_OZONE_WL = "1";
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
    QT_QPA_PLATFORM = "wayland;xcb";
    SDL_VIDEODRIVER = "wayland";
    CLUTTER_BACKEND = "wayland";
    GDK_BACKEND = "wayland,x11";

    # XDG & Screenshare Fixes
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_TYPE = "wayland";
    XDG_SESSION_DESKTOP = "Hyprland";
    XDG_DESKTOP_PORTAL_HYPRLAND_FORCE_SHM = "1"; # Nuclear fix for EIO error
  };
}

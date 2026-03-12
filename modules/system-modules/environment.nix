{ pkgs, ... }:

{
  environment = {
    systemPackages = with pkgs; [
      micro
      nh
    ];
    sessionVariables = {
      EDITOR = "micro";
      NIXOS_OZONE_WL = "1";
      GBM_BACKEND = "nvidia-drm";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      LIBVA_DRIVER_NAME = "nvidia";
      XDG_SESSION_TYPE = "wayland";
      WLR_NO_HARDWARE_CURSORS = "1";
    };
  };
}

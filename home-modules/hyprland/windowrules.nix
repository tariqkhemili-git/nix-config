#{ ... }:

{
  wayland.windowManager.hyprland.settings = {
    layerrule = [
      "match:namespace ^(waybar)$, blur on"
      "match:namespace ^(waybar)$, blur_popups on"
      "match:namespace ^(waybar)$, ignore_alpha 0.2"
    ];

    windowrule = [
      "match:class zen-browser, opacity 0.90 0.90"
      "match:class foot, opacity 0.80 0.80"
      "match:class pavucontrol, float on"
      "match:class bluetuith, float on"
      "match:class equibop, workspace special:equibop silent"
      "match:class gapless, workspace special:gapless silent"
    ];
  };
}

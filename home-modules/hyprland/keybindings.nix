{ ... }:

{
  wayland.windowManager.hyprland.settings = {
    "$mainMod" = "SUPER";
    "$terminal" = "foot";
    "$fileManager" = "dolphin";
    "$menu" = "rofi -show drun";
    "$browser" = "zen-beta";

    bind = [
      "$mainMod, Q, killactive,"
      "$mainMod, F, fullscreen"

      # Launch apps
      "$mainMod, T, exec, $terminal"
      "$mainMod, RETURN, exec, $terminal"
      "$mainMod, E, exec, $fileManager"
      "$mainMod, B, exec, $browser"

      # Focus workspaces
      "$mainMod, Left,  movefocus, l"
      "$mainMod, Right, movefocus, r"
      "$mainMod, Up,    movefocus, u"
      "$mainMod, Down,  movefocus, d"

      # Switch workspaces
      "$mainMod, 1, workspace, 1"
      "$mainMod, 2, workspace, 2"
      "$mainMod, 3, workspace, 3"
      "$mainMod, 4, workspace, 4"
      "$mainMod, 5, workspace, 5"
      "$mainMod, 6, workspace, 6"
      "$mainMod, 7, workspace, 7"
      "$mainMod, 8, workspace, 8"
      "$mainMod, 9, workspace, 9"
      "$mainMod, 0, workspace, 10"

      # Move active window to workspace
      "$mainMod ALT, 1, movetoworkspacesilent, 1"
      "$mainMod ALT, 2, movetoworkspacesilent, 2"
      "$mainMod ALT, 3, movetoworkspacesilent, 3"
      "$mainMod ALT, 4, movetoworkspacesilent, 4"
      "$mainMod ALT, 5, movetoworkspacesilent, 5"
      "$mainMod ALT, 6, movetoworkspacesilent, 6"
      "$mainMod ALT, 7, movetoworkspacesilent, 7"
      "$mainMod ALT, 8, movetoworkspacesilent, 8"
      "$mainMod ALT, 9, movetoworkspacesilent, 9"
      "$mainMod ALT, 0, movetoworkspacesilent, 10"

      # Scratchpad
      "$mainMod, S, togglespecialworkspace, magic"
      "$mainMod ALT, S, movetoworkspace, special:magic"

      # Equibop Scratchpad
      "$mainMod, D, togglespecialworkspace, equibop"
      "$mainMod ALT, D, movetoworkspace, special:equibop"

      # Gapless Scratchpad
      "$mainMod, M, togglespecialworkspace, gapless"
      "$mainMod ALT, M, movetoworkspace, special:gapless"

      # Scroll workspaces
      "$mainMod, mouse_down, workspace, e+1"
      "$mainMod, mouse_up, workspace, e-1"
      "$mainMod SHIFT, C, exec, hyprpicker -a"
      "$mainMod SHIFT, S, exec, hyprshot -z -m region -o $SCREENSHOTS"

      # OCR Screenshot
      "$mainMod SHIFT, O, exec, fish -c hypr-ocr"

      # Clipboard
      "$mainMod, V, exec, cliphist list | rofi -dmenu | cliphist decode | wl-copy"
    ];

    bindm = [
      "$mainMod, mouse:272, movewindow"
      "$mainMod, mouse:273, resizewindow"
    ];

    bindel = [
      ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
      ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
      ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
      ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
      ",XF86MonBrightnessUp, exec, brightnessctl -e4 -n2 set 5%+"
      ",XF86MonBrightnessDown, exec, brightnessctl -e4 -n2 set 5%-"
    ];

    bindl = [
      ", XF86AudioNext, exec, playerctl next"
      ", XF86AudioPause, exec, playerctl play-pause"
      ", XF86AudioPlay, exec, playerctl play-pause"
      ", XF86AudioPrev, exec, playerctl previous"
    ];

    bindr = [
      "$mainMod, SUPER_L, exec, $menu"
    ];
  };
}

{ config, pkgs, ... }:

{
  programs.waybar = {
    enable = true;
    systemd.enable = false;
    settings = {
      mainBar = {
        height = 5;
        spacing = 4;

        modules-left = [
          "custom/logo"
          "hyprland/workspaces"
          "sway/mode"
          "sway/scratchpad"
          "custom/media"
        ];

        modules-center = [
          "clock"
        ];

        modules-right = [
          "mpd"
          "pulseaudio"
          "bluetooth"
          "network"
          "backlight"
          "keyboard-state"
          "tray"
          "custom/power"
        ];

        "custom/logo" = {
          format = "  light";
          tooltip = false;
        };

        "keyboard-state" = {
          numlock = false;
          capslock = true;
          format = "{name} {icon}";
          format-icons = {
            locked = "";
            unlocked = "";
          };
          # Uncomment and replace with your actual keyboard ID from `hyprctl devices` to fix input delay
          # device-path = "/dev/input/by-id/usb-Your_Keyboard-event-kbd";
        };

        "sway/mode" = {
          format = ''<span style="italic">{}</span>'';
        };

        "sway/scratchpad" = {
          format = "{icon} {count}";
          show-empty = false;
          format-icons = [
            ""
            ""
          ];
          tooltip = true;
          tooltip-format = "{app}: {title}";
        };

        "mpd" = {
          format = "{stateIcon} {consumeIcon}{randomIcon}{repeatIcon}{singleIcon}{artist} - {album} - {title} ({elapsedTime:%M:%S}/{totalTime:%M:%S}) ⸨{songPosition}|{queueLength}⸩ {volume}% ";
          format-disconnected = "Disconnected ";
          format-stopped = "{consumeIcon}{randomIcon}{repeatIcon}{singleIcon}Stopped ";
          unknown-tag = "N/A";
          interval = 5;
          consume-icons = {
            on = " ";
          };
          random-icons = {
            off = ''<span color="#87b2d4"></span> '';
            on = " ";
          };
          repeat-icons = {
            on = " ";
          };
          single-icons = {
            on = "1 ";
          };
          state-icons = {
            paused = "";
            playing = "";
          };
          tooltip-format = "MPD (connected)";
          tooltip-format-disconnected = "MPD (disconnected)";
        };

        "tray" = {
          spacing = 10;
        };

        "clock" = {
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          format-alt = "{:%Y-%m-%d}";
        };

        "backlight" = {
          format = "{icon}  {percent}%";
          format-icons = [
            ""
            ""
            ""
            ""
            ""
            ""
            ""
            ""
            ""
          ];
        };

        "network" = {
          format-wifi = "  {signalStrength}%";
          format-ethernet = "󰈀  Connected";
          tooltip-format = "";
          format-linked = "";
          format-disconnected = "󰤮  Offline";
          tooltip = false;
          on-click = "foot -e nmtui";
        };

        "bluetooth" = {
          format = "";
          format-connected = " {num_connections}";
          tooltip-format = "{controller_alias}\t{controller_address}";
          on-click = "foot -e bluetuith";
        };

        "pulseaudio" = {
          format = "{icon}  {volume}%";
          format-bluetooth = "{icon} {format_source}";
          format-bluetooth-muted = " {icon} {format_source}";
          format-muted = " {volume}%";
          format-source = " ";
          format-source-muted = "";
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = [
              ""
              ""
              ""
            ];
          };
          on-click = "pavucontrol";
        };

        "custom/power" = {
          format = "⏻ ";
          tooltip = false;
          on-click = "wlogout";
        };

        "hyprland/workspaces" = {
          format = "";
          all-outputs = true;
          active-only = false;
          on-click = "activate";
        };
      };
    };

    style = ''
      /* General definitions */
      * {
          font-family: "JetBrainsMono Nerd Font", FontAwesome, Roboto, Helvetica, Arial, sans-serif;
          font-size: 14px;
          font-weight: bold;
          border: none;
          border-radius: 0;
          min-height: 0;
          margin: 0;
      }

      window#waybar {
          background: rgba(30, 35, 38, 0.4);
          border-bottom: 1px solid rgba(255, 255, 255, 0.1);
          color: #ffffff;
      }

      /* Right-Click Menu Styling */
      menu {
          background: rgba(30, 35, 38, 0.85);
          border: 1px solid rgba(255, 255, 255, 0.1);
          border-radius: 12px;
          padding: 8px;
      }
      menuitem {
          border-radius: 8px;
          padding: 4px 8px;
          transition: all 0.2s ease-in-out;
      }
      menuitem:hover {
          background: rgba(135, 178, 212, 0.3);
      }

      /* Consistent padding and glassy background for all modules */
      .modules-left > widget > *,
      .modules-center > widget > *,
      .modules-right > widget > * {
          margin: 4px 6px;
          padding: 4px 12px;
          background: rgba(46, 52, 58, 0.5); 
          border: 1px solid rgba(255, 255, 255, 0.05);
          border-radius: 12px;
          color: #ffffff;
      }

      /* Logo Accent */
      #custom-logo {
          color: #87b2d4;
          padding-right: 15px;
      }

      /* Workspace Customisation */
      #workspaces {
          padding: 2px;
      }

      #workspaces button {
          padding: 0 8px;
          margin: 0 2px;
          color: #4f5b66; 
          font-size: 14px; 
          background: transparent;
          border: none;
          transition: all 0.2s ease-in-out;
      }

      #workspaces button.active {
          color: #87b2d4; 
          background: rgba(255, 255, 255, 0.1);
          border-radius: 10px;
          font-size: 14px; 
      }

      #workspaces button:hover {
          color: #ffffff;
          background: rgba(255, 255, 255, 0.15);
          box-shadow: none; 
      }

      /* Module Specific Accents */
      #clock {
          color: #87b2d4;
      }

      #pulseaudio, #network, #backlight, #bluetooth {
          color: #d3d3d3;
      }

      #network.disconnected {
          color: #f53c3c;
      }

      #tray > .passive {
          -gtk-icon-effect: dim;
      }
    '';
  };
}

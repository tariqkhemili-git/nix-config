{ ... }:

{
  services = {
    xserver = {
      enable = true;
      videoDrivers = [ "nvidia" ];
      displayManager = {
        lightdm = {
          enable = false;
        };
      };
      desktopManager = {
        xterm = {
          enable = false;
        };
      };
      xkb = {
        layout = "gb";
        options = "eurosign:e,caps:escape";
      };
    };

    printing = {
      enable = true;
    };

    pulseaudio = {
      enable = false;
    };

    pipewire = {
      enable = true;
      pulse = {
        enable = true;
      };
      alsa = {
        enable = true;
        support32Bit = true;
      };

      wireplumber = {
        extraConfig = {
          "10-default-policy" = {
            "wireplumber.settings" = {
              "device.routes.default-sink-volume" = 1.0;
              "device.routes.default-source-volume" = 0.84;
            };
            "monitor.alsa.rules" = [
              {
                matches = [
                  {
                    "node.name" = "alsa_output.usb-SteelSeries_SteelSeries_Arctis_Nova_5-00.analog-stereo";
                  }
                ];
                actions = {
                  update-props = {
                    "priority.driver" = 1500;
                    "priority.session" = 1500;
                  };
                };
              }
              {
                matches = [
                  {
                    "node.name" = "alsa_input.usb-Shure_Inc_Shure_MV7_-00.mono-fallback";
                  }
                ];
                actions = {
                  update-props = {
                    "priority.driver" = 1500;
                    "priority.session" = 1500;
                  };
                };
              }
            ];
          };
        };
      };
    };

    openssh = {
      enable = true;
    };
    udisks2 = {
      enable = true;
    };
    getty = {
      autologinUser = "light";
    };
    flatpak = {
      enable = true;
      packages = [
        {
          appId = "org.vinegarhq.Sober";
          origin = "flathub";
        }
      ];
      update.auto.enable = true;
    };
  };
}

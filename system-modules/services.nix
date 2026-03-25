{ pkgs, ... }:

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
      jack = {
        enable = true;
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
    ollama = {
      enable = true;
      package = pkgs.ollama-cuda;
      loadModels = [
        "glm-ocr:bf16"
      ];
    };
    open-webui = {
      enable = true;
      port = 8080;
      # Ensure it talks to your local Ollama instance
      environment = {
        OLLAMA_API_BASE_URL = "http://127.0.0.1:11434";
        # Disables the "Check for Updates" bubble for a cleaner, private UI
        WEBUI_AUTH = "true";
      };
    };
    gnome = {
      gnome-keyring = {
        enable = true;
      };
    };
    udev = {
      extraRules = ''
        	# Wooting One Legacy
        	SUBSYSTEM=="hidraw", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="ff01", TAG+="uaccess"
        	SUBSYSTEM=="usb", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="ff01", TAG+="uaccess"

        	# Wooting One update mode
        	SUBSYSTEM=="hidraw", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="2402", TAG+="uaccess"

        	# Wooting Two Legacy
        	SUBSYSTEM=="hidraw", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="ff02", TAG+="uaccess"
        	SUBSYSTEM=="usb", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="ff02", TAG+="uaccess"

        	# Wooting Two update mode
        	SUBSYSTEM=="hidraw", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="2403", TAG+="uaccess"

        	# Generic Wooting devices
        	SUBSYSTEM=="hidraw", ATTRS{idVendor}=="31e3", TAG+="uaccess"
        	SUBSYSTEM=="usb", ATTRS{idVendor}=="31e3", TAG+="uaccess"
        	'';
    };
  };
}

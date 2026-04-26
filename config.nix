{
  pkgs,
  inputs,
  lib,
  config,
  ...
}:
{
  # ------------
  # --- Boot ---
  # ------------
  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        consoleMode = "max";
        configurationLimit = 10;
      };
      efi = {
        canTouchEfiVariables = true;
      };
    };

    plymouth = {
      enable = true;
      theme = "spinner";
    };

    consoleLogLevel = 0;

    initrd = {
      verbose = false;
      systemd = {
        enable = true;
      };
      luks = {
        devices = {
          crypted = {
            device = "/dev/disk/by-uuid/2103bd0c-b53c-4f7c-851a-0ac8fae53ce7";
            crypttabExtraOpts = [ "tpm2-device=auto" ];
          };
        };
      };
      availableKernelModules = [
        "xhci_pci"
        "ahci"
        "nvme"
        "usbhid"
        "usb_storage"
        "sd_mod"
        "tpm_tis"
        "tpm_crb"
      ];
      kernelModules = [
        "nvidia"
        "nvidia_modeset"
        "nvidia_uvm"
        "nvidia_drm"
      ];
    };

    kernelParams = [
      "quiet"
      "boot.shell_on_fail"
      "loglevel=3"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
      "systemd.show_status=false"
      "vt.global_cursor_default=0"
      "video=1920x1080"
    ];

    kernelPackages =
      pkgs.linuxPackagesFor
        inputs.nix-cachyos-kernel.packages.${pkgs.stdenv.hostPlatform.system}.linux-cachyos-latest-lto-x86_64-v3;

    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [ ];

    kernel = {
      sysctl = {
        "net.ipv4.tcp_congestion_control" = "bbr";
        "net.core.default_qdisc" = "cake";
        "net.ipv4.tcp_fastopen" = 3;
        "net.ipv4.tcp_mtu_probing" = 1;

        "vm.swappiness" = 10;
        "vm.vfs_cache_pressure" = 50;
        "vm.dirty_background_ratio" = 5;
        "vm.dirty_ratio" = 10;
        "vm.max_map_count" = 2147483642;
      };
    };
  };
  # ---------------
  # --- Console ---
  # ---------------
  console = {
    keyMap = "uk";
  };
  # -------------------
  # --- Environment ---
  # -------------------
  environment = {
    systemPackages = with pkgs; [
      micro
      nh
    ];
    sessionVariables = {
      EDITOR = "micro";
    };
  };
  # --------------------
  # --- File Systems ---
  # --------------------
  fileSystems = {
    "/" = {
      device = "/dev/mapper/crypted";
      fsType = "btrfs";
      options = [ "subvol=root" ];
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/BAC1-6168";
      fsType = "vfat";
      options = [
        "fmask=0077"
        "dmask=0077"
      ];
    };
    "/nix" = {
      device = "/dev/mapper/crypted";
      fsType = "btrfs";
      options = [ "subvol=nix" ];
    };
    "/persist" = {
      device = "/dev/mapper/crypted";
      fsType = "btrfs";
      options = [ "subvol=persist" ];
    };
    "/var/log" = {
      device = "/dev/mapper/crypted";
      fsType = "btrfs";
      options = [ "subvol=var/log" ];
    };
  };

  swapDevices = [
    {
      device = "/dev/disk/by-uuid/1566ff25-279c-427e-9bfa-d1391d8ce80a";
    }
  ];
  # -------------
  # --- Fonts ---
  # -------------
  fonts = {
    fontconfig = {
      enable = true;
      defaultFonts = {
        sansSerif = [ "Atkinson Hyperlegible Next" ];
        serif = [ "Atkinson Hyperlegible Next" ];
        # Keep JetBrains Mono for your terminal/code needs
        monospace = [ "JetBrainsMono Nerd Font" ];
      };
    };
    packages = with pkgs; [
      atkinson-hyperlegible-next
      nerd-fonts.jetbrains-mono
      font-awesome
    ];
  };
  # ----------------
  # --- Hardware ---
  # ----------------
  hardware = {
    nvidia = {
      modesetting = {
        enable = true;
      };
      open = true;
      package = config.boot.kernelPackages.nvidiaPackages.latest;
      powerManagement = {
        enable = false;
        finegrained = false;
      };
      prime = {
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
        sync = {
          enable = true;
        };
      };
    };

    graphics = {
      enable = true;
      enable32Bit = true;
    };

    cpu = {
      intel = {
        updateMicrocode = true;
      };
    };
    enableRedistributableFirmware = true;
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    logitech = {
      wireless = {
        enable = true;
        enableGraphical = true;
      };
    };
  };
  # ------------
  # --- i18n ---
  # ------------
  i18n = {
    defaultLocale = "en_GB.UTF-8";
  };
  # ------------------
  # --- Networking ---
  # ------------------
  networking = {
    hostName = "nixterminator";
    networkmanager = {
      enable = true;
      wifi = {
        scanRandMacAddress = true;
      };
    };

    # Privacy-focused DNS (Cloudflare)
    nameservers = [
      "1.1.1.1"
      "1.0.0.1"
    ];
    # Firewall Configuration
    firewall = {
      enable = true;
      # Syncthing ports: 22000 (TCP/UDP) for sync, 21027 (UDP) for discovery
      # LocalSend ports: 53317 (TCP/UDP) for transfers and discovery
      allowedTCPPorts = [
        22000
        53317
      ];
      allowedUDPPorts = [
        22000
        21027
        53317
      ];
    };
  };
  # -----------
  # --- Nix ---
  # -----------
  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      auto-optimise-store = true;
    };
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 3d";
      persistent = true;
    };
  };
  # ---------------
  # --- Nixpkgs ---
  # ---------------
  nixpkgs = {
    config = {
      allowUnfree = true;
      permittedInsecurePackages = [
        "olm-3.2.16"
      ];
    };
    hostPlatform = lib.mkDefault "x86_64-linux";
  };
  # ----------------
  # --- Programs ---
  # ----------------
  programs = {
    fish = {
      enable = true;
    };
    hyprland = {
      enable = true;
      xwayland = {
        enable = true;
      };
    };
  };

  # ----------------
  # --- Security ---
  # ----------------
  security = {
    rtkit = {
      enable = true;
    };
    sudo = {
      enable = true;
      extraConfig = ''
        Defaults pwfeedback
        Defaults timestamp_timeout=-1
      '';
    };
    pam = {
      services = {
        light = {
          enableGnomeKeyring = true;
        };
      };
    };
    tpm2 = {
      enable = true;
    };
  };
  # ----------------
  # --- Services ---
  # ----------------
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
  # --------------
  # --- System ---
  # --------------
  system = {
    stateVersion = "25.11";
  };
  # ------------
  # --- Time ---
  # ------------
  time = {
    timeZone = "Europe/London";
  };
  # -------------
  # --- Users ---
  # -------------
  users = {
    mutableUsers = true;
    users = {
      light = {
        isNormalUser = true;
        shell = pkgs.fish;
        extraGroups = [
          "wheel"
          "networkmanager"
          "video"
          "input"
          "wireshark"
        ];
      };
    };
  };

}

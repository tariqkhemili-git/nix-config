{
  pkgs,
  zen-browser,
  config,
  inputs,
  ...
}:

{
  imports = [
    inputs.spicetify-nix.homeManagerModules.default
  ];
  home = {
    username = "light";
    homeDirectory = "/home/light";
    stateVersion = "25.11";
    sessionVariables = {
      GTK_THEME = "Adwaita:dark";
      SCREENSHOTS = "${config.home.homeDirectory}/Pictures/Screenshots";
      PROJECTS = "${config.home.homeDirectory}/Documents/Projects";
      WALLPAPERS = "${config.home.homeDirectory}/Pictures/Wallpapers";

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

      PYTHON_KEYRING_BACKEND = "keyring.backends.libsecret.Keyring";
      ELECTRON_ARGS = "--password-store=gnome-libsecret";
    };
    packages = with pkgs; [
      # --- Terminal & Core Utilities ---
      foot # Primary terminal emulator
      btop # Resource monitor
      fastfetch # System information tool
      tree # Directory visualisation
      bat # Syntax-highlighted cat
      eza # Modern replacement for ls
      fzf # Fuzzy finder
      jq # Command-line JSON processor
      rsync # High-performance file transfer
      ffmpeg # Audio codecs
      yt-dlp # Downloader
      lazygit # Git TUI
      gocryptfs # Encrypted filesystems
      fpart

      # --- Development ---
      python315

      # --- Nix Development & Maintenance ---
      nixd # Nix Language Server
      nixfmt # Nix code formatter
      nix-output-monitor # Better nix-build output
      nvd # Nix package version diff tool
      nh # Nix Helper for clean flake deployments

      # --- Version Control ---
      git # Standard version control
      gh # GitHub CLI

      # --- Hyprland Desktop Environment ---
      waybar # Status bar
      swaynotificationcenter # Notification daemon
      rofi # Application launcher
      cliphist # Clipboard history management
      libnotify # Notification library
      wlogout # Logout menu
      hyprshot # Screenshot utility
      hyprpicker # Colour picker
      wl-clipboard # Wayland clipboard utilities

      # --- Desktop & System Management ---
      pavucontrol # Audio volume control
      brightnessctl # Backlight control
      wlsunset # Night light / gamma adjustment
      bluetuith # TUI Bluetooth manager

      # --- Web Browsers & Communication ---
      zen-browser.packages."${pkgs.stdenv.hostPlatform.system}".default # Primary Browser
      chromium # Chromium browser
      session-desktop # Privacy-focused messenger
      element-desktop # Official Matrix client
      nheko # Fast Matrix client
      keet # P2P chat
      jami # P2P chat
      tg # Privacy messenger
      equibop # Discord chat client

      # --- Productivity & Creative ---
      vscode # Modern code editor
      obsidian # Knowledge management & notes
      onlyoffice-desktopeditors # Full office suite
      nomacs # Image viewer
      mpv # Video player
      cisco-packet-tracer_9 # Cisco Packet Tracer
      gimp # GNU image editor
      libqalculate # CLI Calculator
      qalculate-gtk # Calculator app

      # --- AI & Self-Hosted Services ---
      ollama # Local Large Language Model runner

      # --- Gaming & Entertainment ---
      steam # Gaming platform
      linux-wallpaperengine # Animated wallpapers
      prismlauncher # Minecraft launcher
      mpd # Music Player Daemon

      # --- Theming & Frameworks ---
      gnome-themes-extra # GTK themes
      adwaita-qt # Adwaita theme for Qt apps
      adwaita-qt6 # Adwaita theme for Qt6 apps

      # --- KDE/Dolphin File Manager Components ---
      kdePackages.dolphin # Primary file manager
      kdePackages.qtsvg # SVG support for KDE apps
      kdePackages.kio-extras # Network/SFTP support for Dolphin
      kdePackages.kdegraphics-thumbnailers # Image/Video thumbnails
      kdePackages.kio-fuse # Mounting support for Dolphin
      kdePackages.dolphin-plugins # Git integration for Dolphin

      # --- Security ---
      libsecret
      gnome-keyring
      seahorse
      # -----------------
      # --- Functions ---
      # -----------------
      # pcopy
      (writeShellScriptBin "pcopy" ''
        set -euo pipefail
        trap 'echo -e "\n⚠️ Operation cancelled by user."; exit 1' INT TERM

        if [ "$#" -lt 2 ]; then
          echo "Usage: pcopy <source1> [source2...] <destination>"
          exit 1
        fi

        DST_RAW="''${@: -1}"
        DST=$(${coreutils}/bin/realpath -m "$DST_RAW")

        DST_EXISTS=false
        if [ -e "$DST_RAW" ] || [ -d "$DST_RAW" ]; then DST_EXISTS=true; fi

        SOURCES=("''${@:1:$#-1}")
        NUM_SOURCES=''${#SOURCES[@]}

        echo "🚀 Parallel Copy: Processing $NUM_SOURCES item(s) to $DST_RAW"

        for SRC_RAW in "''${SOURCES[@]}"; do
          SRC=$(${coreutils}/bin/realpath -m "$SRC_RAW")
          BASENAME=$(${coreutils}/bin/basename "$SRC")

          case "$DST/" in "$SRC/"*) echo "⚠️ Skipping $BASENAME: Recursive loop detected."; continue ;; esac

          if [ "$NUM_SOURCES" -eq 1 ] && [ "$DST_EXISTS" = false ]; then
            TARGET_DIR="$DST"
          else
            TARGET_DIR="$DST/$BASENAME"
          fi

          if [ -d "$SRC" ]; then
            ${coreutils}/bin/mkdir -p "$TARGET_DIR"
            set +e
            ${fpart}/bin/fpsync -n 20 -T ${rsync}/bin/rsync -o "-lptgoDWq" "$SRC/" "$TARGET_DIR/"
            set -e
          elif [ -f "$SRC" ]; then
            if [ "$NUM_SOURCES" -eq 1 ] && [ "$DST_EXISTS" = false ]; then
              ${coreutils}/bin/mkdir -p "$(${coreutils}/bin/dirname "$DST")"
              ${rsync}/bin/rsync -lptgoDWq "$SRC" "$DST"
            else
              ${coreutils}/bin/mkdir -p "$DST"
              ${rsync}/bin/rsync -lptgoDWq "$SRC" "$DST/"
            fi
          else
            echo "⚠️ Skipping $SRC_RAW: Not a standard file or directory."
          fi
        done
      '')
      # pmove
      (writeShellScriptBin "pmove" ''
        set -euo pipefail
        trap 'echo -e "\n⚠️ Operation cancelled by user."; exit 1' INT TERM

        if [ "$#" -lt 2 ]; then
          echo "Usage: pmove <source1> [source2...] <destination>"
          exit 1
        fi

        DST_RAW="''${@: -1}"
        DST=$(${coreutils}/bin/realpath -m "$DST_RAW")

        DST_EXISTS=false
        if [ -e "$DST_RAW" ] || [ -d "$DST_RAW" ]; then DST_EXISTS=true; fi

        SOURCES=("''${@:1:$#-1}")
        NUM_SOURCES=''${#SOURCES[@]}

        echo "🚚 Parallel Move (Transactional): Processing $NUM_SOURCES item(s) to $DST_RAW"

        for SRC_RAW in "''${SOURCES[@]}"; do
          SRC=$(${coreutils}/bin/realpath -m "$SRC_RAW")
          BASENAME=$(${coreutils}/bin/basename "$SRC")

          case "$DST/" in "$SRC/"*) echo "⚠️ Skipping $BASENAME: Recursive loop detected."; continue ;; esac

          if [ "$NUM_SOURCES" -eq 1 ] && [ "$DST_EXISTS" = false ]; then
            TARGET_DIR="$DST"
          else
            TARGET_DIR="$DST/$BASENAME"
          fi

          if [ -d "$SRC" ]; then
            ${coreutils}/bin/mkdir -p "$TARGET_DIR"
            
            # Perform the full parallel copy without deleting anything
            set +e
            ${fpart}/bin/fpsync -n 20 -T ${rsync}/bin/rsync -o "-lptgoDWq" "$SRC/" "$TARGET_DIR/"
            EXIT_CODE=$?
            set -e
            
            # Only if the copy was 100% successful, wipe the source
            if [ $EXIT_CODE -eq 0 ]; then
              ${coreutils}/bin/rm -rf "$SRC"
            else
              echo "⚠️ Move interrupted or failed for $BASENAME. Source files kept intact."
            fi

          elif [ -f "$SRC" ]; then
            set +e
            if [ "$NUM_SOURCES" -eq 1 ] && [ "$DST_EXISTS" = false ]; then
              ${coreutils}/bin/mkdir -p "$(${coreutils}/bin/dirname "$DST")"
              ${rsync}/bin/rsync -lptgoDWq "$SRC" "$DST"
            else
              ${coreutils}/bin/mkdir -p "$DST"
              ${rsync}/bin/rsync -lptgoDWq "$SRC" "$DST/"
            fi
            EXIT_CODE=$?
            set -e

            if [ $EXIT_CODE -eq 0 ]; then
              ${coreutils}/bin/rm -f "$SRC"
            else
              echo "⚠️ Move interrupted or failed for $BASENAME. Source file kept intact."
            fi
          else
            echo "⚠️ Skipping $SRC_RAW: Not a standard file or directory."
          fi
        done
      '')
      # pmerge
      (writeShellScriptBin "pmerge" ''
        set -euo pipefail
        trap 'echo -e "\n⚠️ Operation cancelled by user."; exit 1' INT TERM

        if [ "$#" -lt 2 ]; then
          echo "Usage: pmerge <source1> [source2...] <destination>"
          exit 1
        fi

        DST_RAW="''${@: -1}"
        DST=$(${coreutils}/bin/realpath -m "$DST_RAW")

        DST_EXISTS=false
        if [ -e "$DST_RAW" ] || [ -d "$DST_RAW" ]; then DST_EXISTS=true; fi

        SOURCES=("''${@:1:$#-1}")
        NUM_SOURCES=''${#SOURCES[@]}

        echo "🔄 Parallel Merge: Processing $NUM_SOURCES item(s) to $DST_RAW"

        for SRC_RAW in "''${SOURCES[@]}"; do
          SRC=$(${coreutils}/bin/realpath -m "$SRC_RAW")
          BASENAME=$(${coreutils}/bin/basename "$SRC")

          case "$DST/" in "$SRC/"*) echo "⚠️ Skipping $BASENAME: Recursive loop detected."; continue ;; esac

          if [ "$NUM_SOURCES" -eq 1 ] && [ "$DST_EXISTS" = false ]; then
            TARGET_DIR="$DST"
          else
            TARGET_DIR="$DST/$BASENAME"
          fi

          if [ -d "$SRC" ]; then
            ${coreutils}/bin/mkdir -p "$TARGET_DIR"
            set +e
            ${fpart}/bin/fpsync -n 20 -T ${rsync}/bin/rsync -o "-lptgoDWqu" "$SRC/" "$TARGET_DIR/"
            set -e
          elif [ -f "$SRC" ]; then
            if [ "$NUM_SOURCES" -eq 1 ] && [ "$DST_EXISTS" = false ]; then
              ${coreutils}/bin/mkdir -p "$(${coreutils}/bin/dirname "$DST")"
              ${rsync}/bin/rsync -lptgoDWqu "$SRC" "$DST"
            else
              ${coreutils}/bin/mkdir -p "$DST"
              ${rsync}/bin/rsync -lptgoDWqu "$SRC" "$DST/"
            fi
          else
            echo "⚠️ Skipping $SRC_RAW: Not a standard file or directory."
          fi
        done
      '')
      # hypr-ocr
      (pkgs.writeShellScriptBin "hypr-ocr" ''
        # Explicitly pull dependencies from the Nix store
        export PATH="${
          pkgs.lib.makeBinPath [
            pkgs.grim
            pkgs.slurp
            pkgs.tesseract
            pkgs.wl-clipboard
            pkgs.libnotify
            pkgs.coreutils
          ]
        }:$PATH"

        IMAGE_PATH="/tmp/ocr_capture.png"

        # Select region and capture
        if grim -g "$(slurp)" "$IMAGE_PATH"; then
          # Process OCR locally - no data leaves your machine
          tesseract "$IMAGE_PATH" - stdout quiet | wl-copy
          notify-send "OCR Complete" "Text copied to clipboard."
          rm "$IMAGE_PATH"
        else
          notify-send "OCR Cancelled" "No area selected."
        fi
      '')
      # sc-sync-all
      (pkgs.writeShellScriptBin "sc-sync-all" ''
        list_path="/home/light/Documents/Music/music_list.txt"

        if [ -f "$list_path" ]; then
          echo "Syncing with Browser Impersonation and Jitter..."
          # --impersonate chrome: Mimics Chrome's TLS fingerprint to bypass WAFs
          # --sleep-requests 2: Adds a 2s base sleep
          # --sleep-interval 5 --max-sleep-interval 15: Adds random delays to look human
          ${pkgs.yt-dlp}/bin/yt-dlp \
            --rm-cache-dir \
            --force-ipv4 \
            --impersonate "chrome" \
            --sleep-requests 2 \
            --sleep-interval 5 \
            --max-sleep-interval 15 \
            --geo-bypass \
            --referer "https://soundcloud.com/" \
            -a "$list_path" "$@"
        else
          echo "Error: music_list.txt not found at $list_path"
          ${pkgs.kdePackages.dolphin}/bin/dolphin "$(dirname "$list_path")"
        fi
      '')
      # system-report
      (pkgs.writeShellScriptBin "system-report" ''
        # Ensure all required tools are available
        export PATH="${
          pkgs.lib.makeBinPath [
            pkgs.util-linux
            pkgs.lm_sensors
            pkgs.pciutils
            pkgs.coreutils
            pkgs.procps
          ]
        }:$PATH"

        REPORT_DIR="/home/light/Documents/System Info"
        REPORT_FILE="$REPORT_DIR/system-report.md"

        # Ensure directory exists (privacy: keeps info in your local Documents)
        mkdir -p "$REPORT_DIR"

        {
          echo "# System Report - $(date)"
          echo "## Storage (lsblk)"
          lsblk -p
          echo -e "\n## CPU Info"
          lscpu | head -n 20
          echo -e "\n## PCI Devices"
          lspci -vmm
          echo -e "\n## Memory & Uptime"
          uptime
          free -h
          echo -e "\n## Temperatures"
          sensors
        } > "$REPORT_FILE"

        notify-send "System Report" "Report generated at $REPORT_FILE"
      '')
      # extract (Max Performance, Multithreaded, Silent)
      (pkgs.writeShellScriptBin "extract" ''
        set -euo pipefail

        export PATH="${
          pkgs.lib.makeBinPath [
            pkgs.gnutar
            pkgs.unzip
            pkgs.p7zip
            pkgs.zstd
            pkgs.pigz # Parallel gzip
            pkgs.pbzip2 # Parallel bzip2
            pkgs.xz # Supports multithreading via -T0
            pkgs.coreutils
          ]
        }:$PATH"

        if [ "$#" -eq 0 ]; then exit 1; fi

        for FILE in "$@"; do
          if [ -f "$FILE" ]; then
            case "$FILE" in
              *.tar.bz2|*.tbz2) tar -I pbzip2 -xf "$FILE" ;;
              *.tar.gz|*.tgz)   tar -I pigz -xf "$FILE" ;;
              *.tar.xz|*.txz)   tar -I 'xz -T0' -xf "$FILE" ;;
              *.tar.zst)        tar -I 'zstd -T0 -q' -xf "$FILE" ;;
              *.bz2)            pbzip2 -d -q "$FILE" ;;
              *.rar|*.7z)       7z x -bd -bso0 "$FILE" ;;
              *.gz)             pigz -d -q "$FILE" ;;
              *.tar)            tar -xf "$FILE" ;;
              *.zip)            unzip -q "$FILE" ;;
              *.xz)             xz -d -T0 -q "$FILE" ;;
              *.Z)              uncompress "$FILE" ;;
              *)                >&2 echo "Unrecognised: $FILE"; exit 1 ;;
            esac
          fi
        done
      '')

      # compress (Max Performance, Multithreaded, Silent)
      (pkgs.writeShellScriptBin "compress" ''
        set -euo pipefail

        export PATH="${
          pkgs.lib.makeBinPath [
            pkgs.gnutar
            pkgs.zip
            pkgs.p7zip
            pkgs.zstd
            pkgs.pigz # Parallel gzip
            pkgs.pbzip2 # Parallel bzip2
            pkgs.xz # Supports multithreading via -T0
            pkgs.coreutils
          ]
        }:$PATH"

        if [ "$#" -lt 2 ]; then exit 1; fi

        ARCHIVE="$1"
        shift
        SOURCES=("''${@}")

        case "$ARCHIVE" in
          *.tar.zst)        tar -I 'zstd -T0 -q' -cf "$ARCHIVE" "''${SOURCES[@]}" ;;
          *.tar.gz|*.tgz)   tar -I 'pigz -q' -cf "$ARCHIVE" "''${SOURCES[@]}" ;;
          *.tar.bz2|*.tbz2) tar -I 'pbzip2 -q' -cf "$ARCHIVE" "''${SOURCES[@]}" ;;
          *.tar.xz|*.txz)   tar -I 'xz -T0 -q' -cf "$ARCHIVE" "''${SOURCES[@]}" ;;
          *.tar)            tar -cf "$ARCHIVE" "''${SOURCES[@]}" ;;
          *.zip)            zip -rq "$ARCHIVE" "''${SOURCES[@]}" ;;
          *.7z)             7z a -bd -bso0 "$ARCHIVE" "''${SOURCES[@]}" ;;
          *) 
            # Default to max performance zstd if no valid extension is provided
            tar -I 'zstd -T0 -q' -cf "$ARCHIVE.tar.zst" "''${SOURCES[@]}"
            ;;
        esac
      '')
    ];
    pointerCursor = {
      gtk.enable = true;
      x11.enable = true;
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 24;
    };
  };
  # -----------
  # --- Xdg ---
  # -----------
  xdg = {
    userDirs = {
      enable = true;
      createDirectories = true;
      setSessionVariables = false;

      # Base Directories
      download = "${config.home.homeDirectory}/Downloads";
      documents = "${config.home.homeDirectory}/Documents";
      videos = "${config.home.homeDirectory}/Videos";
      pictures = "${config.home.homeDirectory}/Pictures";
      music = "${config.home.homeDirectory}/Music";
      desktop = null; # Keeps the home root clean

      # Custom Subfolders via extraConfig
      extraConfig = {
        SCREENSHOTS = "${config.home.homeDirectory}/Pictures/Screenshots";
        WALLPAPERS = "${config.home.homeDirectory}/Pictures/Wallpapers";
        PROJECTS = "${config.home.homeDirectory}/Documents/Projects";
        BACKUP = "${config.home.homeDirectory}/Documents/Backups";
        VAULT = "${config.home.homeDirectory}/Documents/Vault";
      };
    };
    portal = {
      enable = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-hyprland
        pkgs.xdg-desktop-portal-gtk
      ];
      config.common.default = [ "hyprland" ];
    };
    configFile."yt-dlp/soundcloud.conf".text = ''
      # --- STORAGE ---
      --paths "/home/light/Music"
      --output "%(uploader)s/%(title)s.%(ext)s"

      # --- AUDIO QUALITY ---
      --extract-audio
      --audio-format mp3
      --audio-quality 0

      # --- METADATA & VISUALS ---
      --embed-metadata
      --embed-thumbnail

      # --- SYSTEM & SYNC ---
      --mtime
      --ignore-errors

      # --- PERFORMANCE (NATIVE) ---
      --concurrent-fragments 16

      # --- ANTI-BLOCKING ---
      --user-agent "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
    '';
  };
  # ----------------
  # --- Hyprland ---
  # ----------------
  wayland = {
    windowManager = {
      hyprland = {
        enable = true;
        settings = {
          "$mainMod" = "SUPER";
          "$terminal" = "foot";
          "$fileManager" = "dolphin";
          "$menu" = "rofi -show drun";
          "$browser" = "zen-beta";

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
          exec-once = [
            # --- System Essentials ---
            "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
            "gnome-keyring-daemon --start --components=secrets"
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

            # --- Apps ---
            "equibop"
            "spotify"
          ];
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

            # Spotify Scratchpad
            "$mainMod, M, togglespecialworkspace, spotify"
            "$mainMod ALT, M, movetoworkspace, special:spotify"

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
          monitor = [
            "DP-3, 1920x1080@200, 0x0, 1, bitdepth, 10"
            "HDMI-A-1, 1920x1080@180, 1920x0, 1, bitdepth, 10"
            "DP-2, disable"
          ];
          # --- Layer Rules (Waybar & Wlogout Blurs) ---
          layerrule = [
            "blur, waybar"
            "blur_popups, waybar"
            "ignorealpha 0.2, waybar"
            "blur, wlogout"
            "ignorealpha 0.2, wlogout"
          ];

          # --- Standard Window Rules (V1: RULE, TARGET) ---
          windowrule = [
            "opacity 0.90 0.90, ^(zen-browser)$"
            "opacity 0.80 0.80, ^(foot)$"
            "float, ^(pavucontrol)$"
            "float, ^(bluetuith)$"
            "workspace special:spotify silent, ^(spotify)$"
          ];

          # --- Complex Window Rules (V2: RULE, DICTIONARY) ---
          windowrulev2 = [
            # The Equibop Fix: Maps to the scratchpad using the electron class and title regex
            "workspace special:equibop silent, class:^(electron)$, title:(.*Discord.*|.*Equibop.*)"
          ];
          workspace = [
            "1, monitor:DP-3, default:true"
            "2, monitor:HDMI-A-1, default:true"
            "special:equibop, gapsin:15, gapsout:30"
            "special:spotify, gapsin:15, gapsout:30"
          ];
        };
      };
    };
  };
  programs = {
    fastfetch = {
      enable = true;
      settings = {
        "$schema" = "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json";
        logo = null;
        display = {
          separator = " ›  ";
        };
        modules = [
          "break"
          {
            type = "os";
            key = "OS  ";
            keyColor = "31"; # Red
          }
          {
            type = "kernel";
            key = "KER ";
            keyColor = "32"; # Green
          }
          {
            type = "packages";
            key = "PKG ";
            keyColor = "33"; # Yellow
            # Customised to show Nix packages correctly
            format = "{} (nix)";
          }
          {
            type = "shell";
            key = "SH  ";
            keyColor = "34"; # Blue
          }
          {
            type = "terminal";
            key = "TER ";
            keyColor = "35"; # Magenta
          }
          {
            type = "wm";
            key = "WM  ";
            keyColor = "36"; # Cyan
          }
          "break"
        ];
      };
    };
    fish = {
      enable = true;
      loginShellInit = ''
        if test (tty) = "/dev/tty1"
          exec start-hyprland
        end
      '';
      interactiveShellInit = ''
        set -g fish_greeting ""
        set -g fish_color_command green --bold
        set -g fish_color_keyword magenta
        set -g fish_color_quote yellow
        set -g fish_color_error red
        set -g fish_color_param blue
        export NIXPKGS_ALLOW_UNFREE=1
      '';

      shellAbbrs = {
        upd = "nh os switch -u ~/.nix";
        gitupd = ''z ~/.nix && git add . && git commit -m "" && git push -u origin main && nh os switch -u ~/.nix'';
        swi = "nh os switch ~/.nix";
        gitswi = ''z ~/.nix && git add . && git commit -m "" && git push -u origin main && nh os switch ~/.nix'';
        test = "nh os test ~/.nix";
        clean = "nh clean all";
        nixconf = "z ~/.nix && micro";
        s = "sudo";
        e = "micro";
        cd = "z";
        conf = "z ~/.nix";
        ".." = "z ..";
        dl-sc = "yt-dlp --config-location ~/.config/yt-dlp/soundcloud.conf";
      };

      shellAliases = {
        nix-tree = "tree -J /home/light/.nix > '/home/light/Documents/System Info/nix-tree.json'";
        cat = "bat";
        ls = "eza --icons --group-directories-first";
        ll = "eza -lh --icons --grid --group-directories-first --sort=modified";
        unlock-vault = "gocryptfs ~/Documents/.vault_cipher ~/Documents/Vault";
        lock-vault = "fusermount -u ~/Documents/Vault";
      };
    };
    foot = {
      enable = true;
      # We will disable the automatic Home Manager service and
      # run it manually or let Hyprland start it to avoid session race conditions.
      server.enable = false;

      settings = {
        main = {
          font = "JetBrainsMono Nerd Font:size=11";
          pad = "12x12";
        };

        tweak = {
          # Silences the DejaVu Sans warning
          font-monospace-warn = "no";
        };

        cursor = {
          style = "beam";
          blink = "yes";
        };

        colors-dark = {
          alpha = "0.9";
          background = "1e2326"; # Matches Waybar module background
          foreground = "d3d3d3"; # Soft white text

          ## Normal colours
          regular0 = "1e2326"; # black
          regular1 = "f53c3c"; # red (Alerts)
          regular2 = "99cc99"; # green
          regular3 = "f0c674"; # yellow
          regular4 = "87b2d4"; # blue (Your Accent)
          regular5 = "c397d8"; # magenta
          regular6 = "8abeb7"; # cyan
          regular7 = "d3d3d3"; # white

          ## Bright colours
          bright0 = "4f5b66"; # bright black (Grey-blue inactive)
          bright1 = "f53c3c"; # bright red
          bright2 = "99cc99"; # bright green
          bright3 = "f0c674"; # bright yellow
          bright4 = "87b2d4"; # bright blue (Your Accent)
          bright5 = "c397d8"; # bright magenta
          bright6 = "8abeb7"; # bright cyan
          bright7 = "ffffff"; # bright white
        };
      };
    };
    git = {
      enable = true;

      # Modern structure: Identity and extra config merged into settings
      settings = {
        user = {
          name = "Tariq Khemili";
          email = "240774599+tariqkhemili-git@users.noreply.github.com";
        };

        # Useful additions for a cleaner workflow
        init = {
          defaultBranch = "main";
        };
        pull = {
          rebase = true;
        };
        push = {
          autoSetupRemote = true;
        };

        # Privacy: Prevent your local email/paths from being leaked in certain logs
        core = {
          quotepath = false;
        };
      };

      # British English & Privacy: Ignore common junk files globally
      ignores = [
        "*.swp" # Micro/Vim swap files
        "result" # Nix build results
        ".direnv/" # Development environment cache
        ".DS_Store" # macOS junk if you ever share files
        "*.secret" # Your custom secret pattern
      ];
    };

    delta = {
      enable = true;
      enableGitIntegration = true; # Silences the deprecation warning
      options = {
        line-numbers = true;
        side-by-side = true;
      };
    };
    spicetify = {
      enable = true;
      enabledExtensions =
        with inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system}.extensions; [
          adblockify
          hidePodcasts
          shuffle
        ];
      theme = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system}.themes.hazy;
    };
    starship = {
      enable = true;
      enableFishIntegration = true;
      settings = {
        add_newline = false;
        # Customising the light@nixterminator look
        username = {
          style_user = "bold blue";
          style_root = "black bold red";
          format = "[$user]($style)";
          show_always = true;
        };
        hostname = {
          ssh_only = false;
          format = "@[$hostname](bold cyan) ";
          trim_at = ".";
          disabled = false;
        };
        directory = {
          style = "bold purple";
          truncate_to_repo = true;
        };
        character = {
          success_symbol = "[>](bold green) ";
          error_symbol = "[>](bold red) ";
        };
      };
    };
    waybar = {
      enable = true;
      systemd.enable = false;
      settings = {
        mainBar = {
          # Added margins to float the bar away from the screen edges
          margin-top = 10;
          margin-left = 15;
          margin-right = 15;
          margin-bottom = 0;
          height = 36;
          spacing = 8;

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
            "tray"
            "custom/power"
          ];

          "custom/logo" = {
            format = " ";
            tooltip = false;
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
              off = ''<span color="#4379a2"></span> '';
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
            # Added tooltip formatting to show your local network name and IP securely
            tooltip-format-wifi = "   {essid}\n󰩟  {ipaddr}";
            tooltip-format-ethernet = "󰈀   {ifname}\n󰩟  {ipaddr}";
            format-linked = "";
            format-disconnected = "󰤮  Offline";
            tooltip = true; # Enabled the tooltip
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
            font-family: "JetBrainsMono Nerd Font", FontAwesome, sans-serif;
            font-size: 14px;
            font-weight: bold;
            border: none;
            border-radius: 0;
            min-height: 0;
            margin: 0;
        }

        /* 1. Make the main bar completely transparent. */
        window#waybar {
            background: transparent;
        }

        /* Tooltip Styling - Liquid Glass Hover Popups */
        tooltip {
            background: rgba(20, 25, 30, 0.65);
            border: 1px solid rgba(255, 255, 255, 0.08);
            border-radius: 16px;
            padding: 8px;
            /* Dropshadow for depth */
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.3);
        }

        tooltip label {
            color: #ffffff;
            padding: 4px;
        }

        /* Right-Click Menu Styling - Frosted Glass */
        menu {
            background: rgba(20, 25, 30, 0.75);
            border: 1px solid rgba(255, 255, 255, 0.08);
            border-radius: 16px;
            padding: 8px;
        }
        menuitem {
            border-radius: 8px;
            padding: 4px 8px;
            transition: all 0.2s ease-in-out;
        }
        menuitem:hover {
            background: rgba(67, 121, 162, 0.3);
        }

        /* 2. Pill shaping and liquid-glass look for all modules. */
        .modules-left > widget > *,
        .modules-center > widget > *,
        .modules-right > widget > * {
            margin: 0px 4px;
            padding: 6px 14px;
            background: rgba(20, 25, 30, 0.55); 
            border: 1px solid rgba(255, 255, 255, 0.08);
            border-radius: 24px; 
            color: #ffffff;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.2); 
        }

        /* Logo Accent */
        #custom-logo {
            color: #4379a2;
            font-size: 16px;
            padding: 4px 4px 4px 8px;
            margin: 0;
        }

        #custom-power {
            color: #ffffff;
            padding-left: 10px;   
            padding-right: 5px;
        }

        /* Workspace Customisation */
        #workspaces {
            padding: 2px 4px;
        }

        #workspaces button {
            padding: 0 4px 0 0;
            margin: 0 4px;
            min-width: 24px;
            min-height: 24px;
            border-radius: 50%;
            color: rgba(255, 255, 255, 0.4); 
            background: transparent;
            transition: all 0.3s cubic-bezier(0.25, 0.8, 0.25, 1);
        }

        /* 3. Accent Colour implementation for active workspaces. */
        #workspaces button.active {
            color: #ffffff;
            background: #4379a2; 
            box-shadow: 0 0 10px rgba(67, 121, 162, 0.4);
        }

        #workspaces button:hover {
            color: #ffffff;
            background: rgba(67, 121, 162, 0.5);
            box-shadow: none; 
        }

        /* Module Specific Accents */
        #clock {
            color: #ffffff;
        }

        #pulseaudio, #network, #backlight, #bluetooth, #mpd, #tray {
            color: #e0e0e0;
        }

        #network.disconnected {
            color: #f53c3c;
        }

        #tray > .passive {
            -gtk-icon-effect: dim;
        }
      '';
    };
    zoxide = {
      enable = true;
      enableFishIntegration = true;
    };
    wlogout = {
      enable = true;
      layout = [
        {
          label = "lock";
          action = "loginctl lock-session";
          text = "Lock";
          keybind = "l";
        }
        {
          label = "logout";
          action = "hyprctl dispatch exit 0";
          text = "Logout";
          keybind = "e";
        }
        {
          label = "reboot";
          action = "systemctl reboot";
          text = "Reboot";
          keybind = "r";
        }
        {
          label = "shutdown";
          action = "systemctl poweroff";
          text = "Shutdown";
          keybind = "s";
        }
      ];
      style = ''
        * {
            background-image: none;
            font-family: "JetBrainsMono Nerd Font", FontAwesome, sans-serif;
            font-size: 20px;
            font-weight: bold;
        }

        window {
            /* Extremely subtle background tint, relying on Hyprland's blur */
            background-color: rgba(20, 25, 30, 0.2); 
        }

        button {
            color: #ffffff;
            background-color: rgba(20, 25, 30, 0.55);
            border: 1px solid rgba(255, 255, 255, 0.08);
            border-radius: 36px; /* Liquid glass rounded pills */
            margin: 20px;
            padding: 20px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.3);
            transition: all 0.3s cubic-bezier(0.25, 0.8, 0.25, 1);
            background-repeat: no-repeat;
            background-position: center;
            background-size: 25%;
        }

        button:hover {
            background-color: rgba(67, 121, 162, 0.5); /* Accent colour */
            border: 1px solid rgba(255, 255, 255, 0.15);
            box-shadow: 0 0 15px rgba(67, 121, 162, 0.4);
        }

        /* Map icons directly from the Nix store package */
        #lock { background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/lock.png")); }
        #logout { background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/logout.png")); }
        #reboot { background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/reboot.png")); }
        #shutdown { background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/shutdown.png")); }
      '';
    };
    mpv = {
      enable = true;
      config = {
        # Core video & decoding
        vo = "gpu-next";
        gpu-api = "vulkan";
        hwdec = "nvdec-copy"; # Optimised for cropping/rotation on Nvidia

        # HDR & Colour (The Fix)
        tone-mapping = "bt.2446a";
        target-colorspace-hint = true; # Passes HDR metadata to your HKC monitor

        # Motion Interpolation (200Hz Smoothness)
        video-sync = "display-resample";
        interpolation = true;
        tscale = "oversample";

        # Upscaling
        profile = "high-quality";
        scale = "ewa_lanczossharp";
        dscale = "mitchell";
        cscale = "spline36";

        # Behaviour
        keep-open = true;
        save-position-on-quit = true;
        force-window = "immediate"; # Prevents the background window bug
        loop-playlist = "inf";
      };

      bindings = {
        # Rotates video 90 degrees clockwise per press
        "Alt+r" = ''cycle-values video-rotate "90" "180" "270" "0"'';

        # Useful volume controls
        "UP" = "add volume 5";
        "DOWN" = "add volume -5";
      };
    };
  };
  dconf = {
    settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
    };
  };
  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
    cursorTheme = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
    };
    gtk4.theme = config.gtk.theme;
  };
  qt = {
    enable = true;
    platformTheme.name = "gtk";
    style.name = "adwaita-dark";
  };
  services = {
    wlsunset = {
      enable = true;
      latitude = "51.5";
      longitude = "-0.12";
      temperature = {
        day = 6500;
        night = 3500;
      };
      gamma = "1.0";
    };
  };
}

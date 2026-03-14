{
  pkgs,
  zen-browser,
  config,
  ...
}:

{
  imports = [
    ./modules/home-modules/dconf.nix
    ./modules/home-modules/gtk.nix
    ./modules/home-modules/qt.nix
    ./modules/home-modules/fonts.nix
    ./modules/home-modules/xdg.nix
    ./modules/home-modules/programs/fish.nix
    ./modules/home-modules/programs/git.nix
    ./modules/home-modules/programs/foot.nix
    ./modules/home-modules/programs/waybar.nix
    ./modules/home-modules/programs/starship.nix
    ./modules/home-modules/programs/zoxide.nix
    ./modules/home-modules/programs/fastfetch.nix
    ./modules/home-modules/programs/wlsunset.nix
    ./modules/home-modules/hyprland/hyprland.nix
    ./modules/home-modules/hyprland/general.nix
    ./modules/home-modules/hyprland/keybindings.nix
    ./modules/home-modules/hyprland/monitors.nix
    ./modules/home-modules/hyprland/workspaces.nix
    ./modules/home-modules/hyprland/execs.nix
    ./modules/home-modules/hyprland/windowrules.nix
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

      # --- Nix Development & Maintenance ---
      nixd # Nix Language Server
      nixfmt # Nix code formatter
      nix-output-monitor # Better nix-build output
      nvd # Nix package version diff tool
      nh # Nix Helper for clean flake deployments

      # --- Version Control ---
      git # Standard version control
      gh # GitHub CLI

      # --- Compression Tools ---
      zstd # Fast real-time compression
      gnutar # Standard archive utility

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
      session-desktop # Privacy-focused messenger
      equibop # Discord chat client

      # --- Productivity & Creative ---
      vscode # Modern code editor
      obsidian # Knowledge management & notes
      libreoffice # Full office suite
      nomacs # Image viewer
      showtime # Video player

      # --- AI & Self-Hosted Services ---
      ollama # Local Large Language Model runner

      # --- Gaming & Entertainment ---
      steam # Gaming platform
      linux-wallpaperengine # Animated wallpapers
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

      # --- Custom Scripts ---
      (pkgs.writeShellScriptBin "system-report" (
        builtins.readFile ./modules/home-modules/functions/system-report.sh
      )) # Custom hardware report script
      (pkgs.writeShellScriptBin "hypr-ocr" (
        builtins.readFile ./modules/home-modules/functions/hypr-ocr.sh
      )) # Custom OCR script for Hyprland
    ];
    pointerCursor = {
      gtk.enable = true;
      x11.enable = true;
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 24;
    };
  };
}

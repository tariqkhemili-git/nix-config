{
  pkgs,
  zen-browser,
  system,
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
    ./modules/home-modules/programs/ocr.nix
    ./modules/home-modules/hyprland/hyprland.nix
    ./modules/home-modules/hyprland/general.nix
    ./modules/home-modules/hyprland/keybindings.nix
    ./modules/home-modules/hyprland/monitors.nix
    ./modules/home-modules/hyprland/workspaces.nix
    ./modules/home-modules/hyprland/env.nix
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
    };
    packages = with pkgs; [
      foot
      btop
      fastfetch
      git
      gh
      nixd
      nixfmt
      tree
      bat
      eza
      nix-output-monitor
      nvd
      fzf
      zstd
      gnutar
      waybar
      swaynotificationcenter
      rofi
      cliphist
      libnotify
      linux-wallpaperengine
      steam
      hyprshot
      wl-clipboard
      hyprpicker
      pavucontrol
      brightnessctl
      wlsunset
      mpd
      zen-browser.packages."${system}".default
      kdePackages.dolphin
      kdePackages.qtsvg
      kdePackages.kio-extras
      kdePackages.kdegraphics-thumbnailers
      kdePackages.kio-fuse
      kdePackages.dolphin-plugins
      equibop
      session-desktop
      gnome-themes-extra
      adwaita-qt
      adwaita-qt6
      wlogout
      bluetuith
      mpd
      rsync
      nomacs
      showtime
      libreoffice
      proton-authenticator
      obsidian
      ollama
      jq
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

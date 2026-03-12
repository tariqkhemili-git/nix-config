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
    ./modules/hyprland/hyprland.nix
    ./modules/hyprland/general.nix
    ./modules/hyprland/keybindings.nix
    ./modules/hyprland/monitors.nix
    ./modules/hyprland/workspaces.nix
    ./modules/hyprland/env.nix
    ./modules/hyprland/execs.nix
    ./modules/hyprland/windowrules.nix
    ./modules/programs/fish.nix
    ./modules/programs/git.nix
    ./modules/programs/foot.nix
    ./modules/programs/waybar.nix
    ./modules/programs/starship.nix
    ./modules/programs/zoxide.nix
    ./modules/programs/fastfetch.nix
    ./modules/programs/wlsunset.nix
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
      nerd-fonts.jetbrains-mono
      font-awesome
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

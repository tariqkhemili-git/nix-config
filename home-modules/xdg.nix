{ config, pkgs, ... }:
{
  xdg = {
    userDirs = {
      enable = true;
      createDirectories = true;

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
  };
}

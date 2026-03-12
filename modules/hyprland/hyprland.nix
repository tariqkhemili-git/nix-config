{ ... }:

{
  imports = [
    ./monitors.nix
    ./general.nix
    ./keybindings.nix
    ./workspaces.nix
  ];

  wayland.windowManager.hyprland.enable = true;
}

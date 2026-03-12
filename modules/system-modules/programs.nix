{ ... }:

{
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
}

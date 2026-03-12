{ pkgs, ... }:

{
  programs.foot = {
    enable = true;
    # We will disable the automatic Home Manager service and
    # run it manually or let Hyprland start it to avoid session race conditions[cite: 178, 179].
    server.enable = false;

    settings = {
      main = {
        font = "JetBrainsMono Nerd Font:size=11";
        pad = "12x12";
      };

      tweak = {
        # Silences the DejaVu Sans warning [cite: 181]
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
}

{ ... }:

{
  programs.fastfetch = {
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
}

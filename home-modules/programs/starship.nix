{ ... }:

{
  programs.starship = {
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
}

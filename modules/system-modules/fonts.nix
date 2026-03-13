{ pkgs, ... }:

{
  fonts = {
    # This enables font discovery for applications like Firefox and Obsidian
    fontconfig.enable = true;

    packages = with pkgs; [
      atkinson-hyperlegible-next # Moved from home.packages
      nerd-fonts.jetbrains-mono # Moved from home.packages
      font-awesome # Moved from home.packages
    ];
  };
}

{ pkgs, ... }:

{
  users = {
    mutableUsers = true;
    users = {
      light = {
        isNormalUser = true;
        shell = pkgs.fish;
        extraGroups = [
          "wheel"
          "networkmanager"
          "video"
          "input"
        ];
      };
    };
  };
}

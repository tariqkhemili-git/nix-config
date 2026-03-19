{ ... }:

{
  security = {
    rtkit = {
      enable = true;
    };
    sudo = {
      enable = true;
      extraConfig = ''
        Defaults pwfeedback
      '';
    };
  };
}

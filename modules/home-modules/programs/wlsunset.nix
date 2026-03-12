{ pkgs, ... }:

{
  services.wlsunset = {
    enable = true;
    latitude = "51.5";
    longitude = "-0.12";
    temperature = {
      day = 6500;
      night = 3500;
    };
    gamma = "1.0";
  };
}

{ lib, ... }:

{
  nixpkgs = {
    config = {
      allowUnfree = true;
      permittedInsecurePackages = [
        "olm-3.2.16"
      ];
    };
    hostPlatform = lib.mkDefault "x86_64-linux";
  };
}

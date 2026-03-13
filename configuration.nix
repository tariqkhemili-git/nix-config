{ inputs, ... }:

{
  imports = [
    # Explicit System Imports
    ./modules/system-modules/boot.nix
    ./modules/system-modules/console.nix
    ./modules/system-modules/environment.nix
    ./modules/system-modules/fileSystems.nix
    ./modules/system-modules/hardware.nix
    ./modules/system-modules/i18n.nix
    ./modules/system-modules/networking.nix
    ./modules/system-modules/nix.nix
    ./modules/system-modules/nixpkgs.nix
    ./modules/system-modules/programs.nix
    ./modules/system-modules/security.nix
    ./modules/system-modules/services.nix
    ./modules/system-modules/system.nix
    ./modules/system-modules/time.nix
    ./modules/system-modules/users.nix
    ./modules/system-modules/fonts.nix

    # Home Manager Integration
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users = {
      light = import ./home.nix;
    };
    extraSpecialArgs = {
      inherit (inputs) zen-browser;
    };
  };
}

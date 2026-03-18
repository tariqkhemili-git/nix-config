{ inputs, ... }:

{
  imports = [
    # Explicit System Imports
    ./system-modules/boot.nix
    ./system-modules/console.nix
    ./system-modules/environment.nix
    ./system-modules/fileSystems.nix
    ./system-modules/hardware.nix
    ./system-modules/i18n.nix
    ./system-modules/networking.nix
    ./system-modules/nix.nix
    ./system-modules/nixpkgs.nix
    ./system-modules/programs.nix
    ./system-modules/security.nix
    ./system-modules/services.nix
    ./system-modules/system.nix
    ./system-modules/time.nix
    ./system-modules/users.nix
    ./system-modules/fonts.nix

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
      inherit inputs;
      inherit (inputs) zen-browser;
    };
  };
}

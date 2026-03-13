{
  description = "NixTerminator System Flake";

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs = {
        nixpkgs = {
          follows = "nixpkgs";
        };
      };
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
    };
    nix-cachyos-kernel = {
      url = "github:xddxdd/nix-cachyos-kernel";
      inputs = {
        nixpkgs = {
          follows = "nixpkgs";
        };
      };
    };
    nix-flatpak = {
      url = "github:gmodena/nix-flatpak";
    };
  };

  outputs =
    { nixpkgs, nix-flatpak, ... }@inputs:
    {
      nixosConfigurations = {
        nixterminator = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [
            ./configuration.nix
            nix-flatpak.nixosModules.nix-flatpak
          ];
        };
      };
    };
}

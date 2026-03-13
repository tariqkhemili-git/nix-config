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
      url = "github:gvolpe/nix-flatpak";
    };
  };

  outputs =
    { nixpkgs, ... }@inputs:
    let
      system = "x86_64-linux";
    in
    {
      nixosConfigurations = {
        nixterminator = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            ./configuration.nix
            inputs.nix-flatpak.nixosModules.nix-flatpak
          ];
        };
      };
    };
}

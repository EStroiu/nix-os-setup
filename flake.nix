{
  description = "My NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia.url = "github:noctalia-dev/noctalia";
  };

  outputs = inputs@{ self, nixpkgs, home-manager, ... }:

    let
      mkHost = hostname:
        nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";

          modules = [
            ./hosts/${hostname}/configuration.nix

            home-manager.nixosModules.home-manager

            {
              home-manager.extraSpecialArgs = {
                inherit inputs;
              };
            }
          ];
        };
    in
    {
      nixosConfigurations = {
        personal-laptop-nixos = mkHost "personal-laptop-nixos";
        work-laptop-nixos = mkHost "work-laptop-nixos";
      };
    };
}

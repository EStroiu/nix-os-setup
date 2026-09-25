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

  outputs = inputs@{ self, nixpkgs, home-manager, ... }: {
    nixosConfigurations.personal-laptop-nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      modules = [
        ./hosts/personal-laptop-nixos/configuration.nix

        home-manager.nixosModules.home-manager

        {
          home-manager.extraSpecialArgs = {
            inherit inputs;
          };
        }
      ];
    };

    nixosConfigurations.work-laptop-nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      
      modules = [
        ./hosts/work-laptop-nixos/configuration.nix

        home-manager.nixosModules.home-manager

        {
          home-manager.extraSpecialArgs = {
            inherit inputs;
          };
        }
      ];
    };
  };
}

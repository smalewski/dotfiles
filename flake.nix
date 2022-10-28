{
  description = "My configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs = { nixpkgs, home-manager, nixos-hardware, ... }:
    let
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;
        config = { allowUnfree = true; };
      };

      lib = nixpkgs.lib;
    in
    {
      nixosConfigurations = {
        lembook-T460 = lib.nixosSystem {
          inherit system pkgs;
          modules = [
            nixos-hardware.nixosModules.lenovo-thinkpad-t460
            ./system/configuration.nix
          ];
        };
      };

      homeConfigurations.lembook-T460 = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ ./home/home.nix ];
      };
    };
}

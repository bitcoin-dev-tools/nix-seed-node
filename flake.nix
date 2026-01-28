{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.disko.url = "github:nix-community/disko";
  inputs.disko.inputs.nixpkgs.follows = "nixpkgs";
  inputs.home-manager.url = "github:nix-community/home-manager";
  inputs.home-manager.inputs.nixpkgs.follows = "nixpkgs";

  outputs = { nixpkgs, disko, home-manager, ... }:
    let
      hostConfig = {
        publicIP = "148.251.128.115";
      };
    in
    {
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;
      nixosConfigurations = {
        # Hetzner AX52 specific configuration
        ax52 = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit hostConfig; };
          modules = [
            disko.nixosModules.disko
            home-manager.nixosModules.home-manager
            ./configuration.nix
            ./disks/disk-config-ax52.nix
            ./nix-channel-setup.nix
          ];
        };
      };
    };
}

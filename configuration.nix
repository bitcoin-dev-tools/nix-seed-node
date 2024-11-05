{ modulesPath, lib, pkgs, ... }:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    ./modules/bitcoin.nix
    ./modules/packages.nix
    ./modules/security.nix
    ./modules/system.nix
    ./modules/users.nix
  ];

  boot.loader.grub = {
    efiSupport = true;
    efiInstallAsRemovable = true;
  };
}

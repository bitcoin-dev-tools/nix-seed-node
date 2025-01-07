{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    bitcoin
  ];
}

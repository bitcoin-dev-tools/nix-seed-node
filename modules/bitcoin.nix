{ config, lib, pkgs, ... }:
{
  services.bitcoind.node = {
    enable = true;
    dbCache = 16000;
    extraConfig = ''
      listen=1
      server=1
    '';
  };

  networking.firewall.allowedTCPPorts = [ 8333 8332 ];
}

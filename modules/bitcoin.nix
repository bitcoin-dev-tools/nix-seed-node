{ config, lib, pkgs, ... }:
{
  services.bitcoind.node = {
    enable = true;
    dbCache = 16000;

    # Benchmark nodes can be whitelisted by connecting to the whitebind port.
    # Note: this could be changed to `whitelist` of ip addresses if abused
    #
    # Add the following option to extraConfig to disable outbound connections
    # noconnect=1
    extraConfig = ''
      listen=1
      server=1
      whitebind=download,noban@0.0.0.0:55555
    '';
  };

  networking.firewall.allowedTCPPorts = [ 8333 8332 55555 ];
}

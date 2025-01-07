{ ... }:
{
  services.bitcoind.signet = {
    enable = true;
    dbCache = 16000;
    extraCmdlineOptions = [ "-signet" ];

    # Benchmark nodes can be whitelisted by connecting to the whitebind port.
    # Note: this could be changed to `whitelist` of ip addresses if abused
    #
    # Add the following option to extraConfig to disable outbound connections
    # noconnect=1
    extraConfig = ''
      [signet]
      listen=1
      noconnect=1
      server=1
      whitebind=download,noban@0.0.0.0:38333
      whitebind=download,noban@0.0.0.0:55555
    '';
  };

  services.bitcoind.mainnet = {
    enable = true;
    dbCache = 16000;

    # Benchmark nodes can be whitelisted by connecting to the whitebind port.
    # Note: this could be changed to `whitelist` of ip addresses if abused
    #
    # Add the following option to extraConfig to disable outbound connections
    # noconnect=1
    extraConfig = ''
      listen=1
      noconnect=1
      server=1
      whitebind=download,noban@0.0.0.0:8333
      whitebind=download,noban@0.0.0.0:33333
    '';
  };

  networking.firewall.allowedTCPPorts = [ 8333 33333 38333 55555 ];
}

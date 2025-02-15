{ ... }:
let
  whitelisted_ips = [ "148.251.128.115" "65.21.224.151" ];
  bitcoin_ports = [ 8333 33333 38333 55555 ];
in {
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

  networking.nftables = {
    enable = true;
    ruleset = ''
      table inet filter {
        chain input {
          type filter hook input priority 0;

          # Allow established connections
          ct state {established, related} accept

          # Allow localhost
          iifname lo accept

          # Allow whitelisted IPs for Bitcoin ports
          ${
            builtins.concatStringsSep "\n          " (map (ip:
              "ip saddr ${ip} tcp dport { ${
                builtins.concatStringsSep ", " (map toString bitcoin_ports)
              } } accept") whitelisted_ips)
          }

          # Drop other Bitcoin port connections
          tcp dport { ${
            builtins.concatStringsSep ", " (map toString bitcoin_ports)
          } } drop
        }
      }
    '';
  };

  # Still need to declare the ports as allowed
  networking.firewall.allowedTCPPorts = bitcoin_ports;
}

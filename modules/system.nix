{ ... }:
{
  time.timeZone = "UTC";

  networking = {
    useDHCP = false;
    interfaces.eno1.ipv4.addresses = [{
      address = "148.251.128.115";
      prefixLength = 27;
    }];
    defaultGateway = "148.251.128.97";
    nameservers = [ "185.12.64.1" "185.12.64.2" ];
  };

  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };

    settings = {
      experimental-features = [ "nix-command" "flakes" ];
    };
  };

  services = {
    journald.extraConfig = ''
      SystemMaxUse=500M
      MaxRetentionSec=1month
    '';

    fstrim = {
      enable = true;
      interval = "weekly";
    };
  };

  environment = {
    variables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      PAGER = "less";
    };
  };

  system.stateVersion = "unstable";
}

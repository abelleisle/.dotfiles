{ lib, config, ... }:
let
  cfg = config.templates.system.networking.dns;
in
{
  options.templates.system.networking.dns = with lib; {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable DNS secure settings";
    };
    verboseLogs = mkOption {
      type = types.bool;
      default = false;
      description = "Enable verbose DNS proxy logs";
    };
  };
  config =
    with lib;
    mkIf cfg.enable {
      networking = {
        nameservers = [
          "127.0.0.1"
          "::1"
        ];
      };

      services = {
        # Disable systemd DNS resolver
        resolved.enable = false;

        # Enable DNS Proxy for DNS-over-HTTPs
        dnsproxy = {
          enable = true;
          settings = {
            # Plaintext DNS to bootstrap DoH
            bootstrap = [
              "[2620:fe::fe]:53"
              "9.9.9.9:53"
            ];

            # DNS over HTTPS upstream
            upstream = [ "https://dns.quad9.net/dns-query" ];

            # Plain DNS server
            listen-addrs = [
              "127.0.0.1"
              "::1"
            ];
            listen-ports = [ 53 ];
          };
          # Additional launch flags
          flags = mkIf cfg.verboseLogs [ "--verbose" ];
        };
      };
    };
}

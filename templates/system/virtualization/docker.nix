{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.templates.system.virtualization.docker;
in
{
  options.templates.system.virtualization.docker = with lib; {
    enable = mkEnableOption "Enable docker";
    users = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "List of users to add to docker group";
      example = [
        "alice"
        "bob"
      ];
    };
  };

  config =
    with lib;
    mkIf cfg.enable {
      virtualisation.docker = {
        enable = true;
        daemon.settings = {
          userland-proxy = false;
          experimental = true;
          metrics-addr = "0.0.0.0:9323";
          ipv6 = true;
          fixed-cidr-v6 = "fd00::/80";
        };
        extraPackages = with pkgs; [
          docker-buildx
        ];
      };
      users.extraGroups.docker.members = cfg.users;
      environment.systemPackages = with pkgs; [
        docker-language-server
      ];
    };
}

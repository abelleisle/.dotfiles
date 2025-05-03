{ lib, isVM, pkgs, ... }:
{
  imports = [
    ./plymouth.nix
    ../../modules/system/laptop.nix
  ];

  services = {
    # Use sddm (wayland) as the greeter
    displayManager = {
      sddm = {
        enable = true;
        wayland = {
          enable = true;
        };
      };
    };

    # Install plasma6
    desktopManager = {
      plasma6 = {
        enable = true;
      };
    };

    # Remap keys to colemake-d
    kmonad = {
      enable = true;
      keyboards = {
        "colemak-d-extended-ansi" = {
          device = "/dev/input/by-path/platform-i8042-serio-0-event-kbd";
          config = builtins.readFile ./keymaps/colemak-d-extend-ansi.kbd;
        };
      };
    };

    mullvad-vpn = {
      enable = true;
      enableExcludeWrapper = false;
    };

    # This is a laptop, automatically set the timezone
    # Note: This is currently broken due to
    #       https://github.com/NixOS/nixpkgs/issues/321121
    # automatic-timezoned.enable = true;

    resolved.enable = true;
  };

  time.timeZone = "America/New_York";

  programs = {
    # Also enable hyprland wm
    hyprland = {
      enable = true;
    };

    # Enable dconf to fix theming on wayland GTK apps (firefox)
    dconf = {
      enable = true;
    };

    # Enable kdeconnect
    kdeconnect.enable = true;
  };

  environment = {
    sessionVariables = lib.mkIf (isVM) {
      WLR_RENDERER_ALLOW_SOFTWARE = "1";
    };
    plasma6.excludePackages = with pkgs.kdePackages; [
      konsole
      konqueror
    ];
  };

  networking = {
    networkmanager = {
      enable = true;
      wifi = {
        powersave = true;
      };

      ## To use, put this in your configuration, switch to it, and restart NM:
      ## $ sudo systemctl restart NetworkManager.service
      ## To check if it works, you can do `sudo systemctl status systemd-timesyncd.service`
      ## (it may take a bit of time to pick the right NTP as it may try the
      ## other NTP firsts)
      dispatcherScripts = [
        {
          # https://wiki.archlinux.org/title/NetworkManager#Dynamically_set_NTP_servers_received_via_DHCP_with_systemd-timesyncd
          # You can debug with sudo journalctl -u NetworkManager-dispatcher -e
          # make sure to restart NM as described above
          source = pkgs.writeText "10-update-timesyncd" ''
            [ -z "$CONNECTION_UUID" ] && exit 0
            INTERFACE="$1"
            ACTION="$2"
            case $ACTION in
            up | dhcp4-change | dhcp6-change)
                systemctl restart systemd-timesyncd.service
                if [ -n "$DHCP4_NTP_SERVERS" ]; then
                  echo "Will add the ntp server $DHCP4_NTP_SERVERS"
                else
                  echo "No DHCP4 NTP available."
                  exit 0
                fi
                mkdir -p /etc/systemd/timesyncd.conf.d
                # <<-EOF must really use tabs to keep indentation correct… and tabs are often converted to space in wiki
                # so I don't want to risk strange issues with indentation
                echo "[Time]" > "/etc/systemd/timesyncd.conf.d/''${CONNECTION_UUID}.conf"
                echo "NTP=$DHCP4_NTP_SERVERS" >> "/etc/systemd/timesyncd.conf.d/''${CONNECTION_UUID}.conf"
                systemctl restart systemd-timesyncd.service
                ;;
            down)
                rm -f "/etc/systemd/timesyncd.conf.d/''${CONNECTION_UUID}.conf"
                systemctl restart systemd-timesyncd.service
                ;;
            esac
            echo 'Done!'
          '';
        }
      ];
    };

    wg-quick.interfaces = {
      "mgmt0" = {
        autostart = true;
        configFile = "/etc/wireguard/mgmt0.conf";
      };
    };
  };

  environment.systemPackages = [
    pkgs.nfs-utils
  ];

  catppuccin = {
    sddm = {
      enable = true;
      flavor = "frappe";
    };
    plymouth = {
      enable = true;
      flavor = "frappe";
    };
  };
}

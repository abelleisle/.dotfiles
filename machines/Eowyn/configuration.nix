{
  lib,
  isVM,
  pkgs,
  ...
}:
{
  imports = [
    ./plymouth.nix
    ../../modules/system/laptop.nix
  ];

  services = {
    # Use sddm (wayland) as the greeter
    displayManager = {
      sddm = {
        enable = false;
        wayland = {
          enable = false;
        };
      };
      gdm = {
        enable = true;
        debug = false;
      };
    };

    # Install plasma6
    desktopManager = {
      plasma6 = {
        enable = false;
      };
      gnome = {
        enable = true;
        debug = false;
      };
    };

    # Remap keys to colemak-d
    kmonad = {
      enable = true;
      keyboards = {
        "colemak-d-extended-ansi" = {
          device = "/dev/input/by-path/platform-i8042-serio-0-event-kbd";
          config = builtins.readFile ./keymaps/colemak-d-extend-ansi.kbd;
        };
      };
    };

    # Allow the use of mullvad VPN on this computer
    mullvad-vpn = {
      enable = true;
      enableExcludeWrapper = false;
    };

    # This is a laptop, automatically set the timezone
    # Note: This is currently broken due to
    #       https://github.com/NixOS/nixpkgs/issues/321121
    # automatic-timezoned.enable = true;

    # Enable network time syncing
    chrony = {
      enable = true;
      enableNTS = true; # Enable the more secure NTS protocol
      # Default NixOS servers don't have NTS support so we have to override
      servers = [
        "time.cloudflare.com"
        "ohio.time.system76.com"
        "oregon.time.system76.com"
        "virginia.time.system76.com"
      ];
    };

    meshcentral = {
      enable = true;
      settings = {
        Port = 4430;
      };
    };

    tailscale = {
      enable = true;
      useRoutingFeatures = "client";
      authKeyFile = "/etc/tailscale/tailscale0_key";
    };

    protonmail-bridge = {
      enable = true;
      path = with pkgs; [
        pass
        gnome-keyring
      ];
    };

    upower = {
      enable = true;
    };
  };

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
    kdeconnect.enable = false;

    ladybird = {
      enable = false;
    };

    winbox = {
      enable = true;
      openFirewall = true;
      package = pkgs.winbox4;
    };
  };

  environment = {
    sessionVariables = lib.mkIf isVM {
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
        autostart = false;
        configFile = "/etc/wireguard/mgmt0.conf";
      };
    };

  };

  environment.systemPackages = [
    pkgs.efibootmgr
    pkgs.nfs-utils
    pkgs.gnomeExtensions.appindicator
    pkgs.gnomeExtensions.user-themes
    pkgs.gnomeExtensions.caffeine
    pkgs.gnomeExtensions.blur-my-shell
    pkgs.gnome-tweaks
    pkgs.wl-clipboard
    pkgs.adwaita-icon-theme
    pkgs.kdePackages.breeze-icons
    pkgs.iotop
  ];
  services.udev.packages = [ pkgs.gnome-settings-daemon ];

  # Configure the virt-manager template
  templates.system.virtualization = {
    docker = {
      enable = true;
      users = [ "andy" ]; # List of users to add to the docker group
    };

    virt-manager = {
      enable = true;
      users = [ "andy" ]; # List of users to add to libvirtd group
      pciPassthrough = {
        enable = true;
        cpu = "intel";
        # extraDrivers = ["i915"]
      };
    };
  };

  templates.system.networking.dns = {
    enable = false;
  };

  programs.captive-browser = {
    enable = true;
    interface = "wlp0s20f3";
  };

  catppuccin = {
    sddm = {
      enable = false;
      flavor = "frappe";
    };
    plymouth = {
      enable = false;
      flavor = "frappe";
    };
  };

  boot.kernel.sysctl."net.ipv4.ip_default_ttl" = 65;
}

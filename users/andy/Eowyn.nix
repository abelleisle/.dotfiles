{ pkgs, config, ... }:
{
  imports = [ ];

  colors.theme = "catppuccin_frappe";

  home = {
    file = {
      ".shelf/nvim.lua".text = ''
        local M = {}

        M.setup = function()
            -------------------
            --  THEME STUFF  --
            -------------------

            -- require("colors.catppuccin").config("frappe")
            local utils = require("utils")
            local theme = utils.get_gnome_theme()
            if theme == "dark" then
              vim.api.nvim_set_option("background", "dark")
            elseif theme == "light" then
              vim.api.nvim_set_option("background", "light")
            end
            require("colors.adwaita").config()
            -- vim.schedule(
            --   function()
            --     require("colors.adwaita").config()
            --   end
            -- )

            ------------------------
            --  VIM CONFIG STUFF  --
            ------------------------

            vim.opt.wrap = false
            vim.g.nix = true
        end

        return M
      '';
    };

    packages = with pkgs; [
      speedcrunch
      prismlauncher
      # (catppuccin-kde.override {
      #   accents = [ "blue" ];
      #   flavour = [ "frappe" ];
      #   winDecStyles = [ "modern" "classic" ];
      # })
      gimp
      # jellyfin-media-player # Have to disable because it uses EOL QT5
      logseq
      ollama
      meshcentral
      dig
      claude-code
      slack
      filezilla
    ];

  };

  # Allow jellyfin-media-player to get controlled via mpris
  xdg.dataFile."jellyfinmediaplayer/scripts/mpris.so".source =
    "${pkgs.mpvScripts.mpris}/share/mpv/scripts/mpris.so";

  services = {
    syncthing = {
      enable = true;
    };
  };

  dotfiles = {
    wm.hyprland = {
      enable = false;
      config = ''
        monitor=,preferred,auto,1
      '';
    };

    programs = {
      personal.enable = true;
      email.enable = true;
      browser.enable = true;
    };

    keyboard.enable = true;
  };

  # Override libGL since this is not a nixOS system
  # nixGLPrefix = "${pkgs.nixgl.nixGLIntel}/bin/nixGLIntel";
  # programs.wezterm.package = (nixGL pkgs.wezterm);

  catppuccin = {
    enable = false;
    flavor = "frappe";
    accent = "blue";
    cursors = {
      enable = false;
    };
    kvantum = {
      enable = false;
      apply = false;
    };
    gtk = {
      # enable = true;
      icon = {
        enable = false;
      };
    };
  };

  gtk = {
    enable = true;
    # theme = {
    # package = pkgs.marble-shell-theme;
    # name = "Marble-red";
    # package = pkgs.matcha-gtk-theme;
    # name = "Matcha-dark-aliz";
    # };
    iconTheme = {
      package = pkgs.papirus-icon-theme;
      name = "Papirus";
    };
    cursorTheme = {
      inherit (config.home.pointerCursor) name;
      inherit (config.home.pointerCursor) package;
      inherit (config.home.pointerCursor) size;
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "qtct";
    style.name = "kvantum";
  };

  # xdg.portal = {
  #   enable = true;
  #   config.common.default = ["gtk"];
  #   extraPortals = with pkgs; [xdg-desktop-portal-gtk];
  # };

  home.pointerCursor =
    let
      getFrom = url: hash: name: {
        gtk.enable = true;
        x11.enable = false;
        inherit name;
        size = 24;
        package = pkgs.runCommand "moveUp" { } ''
          mkdir -p $out/share/icons
          ln -s ${
            pkgs.fetchzip {
              inherit url;
              inherit hash;
            }
          } $out/share/icons/${name}
        '';
      };
    in
    getFrom "https://github.com/ful1e5/fuchsia-cursor/releases/download/v2.0.1/Fuchsia-Pop.tar.xz"
      "sha256-rjeDa/hRZVOS8XeTWEG0Uzf3nTWPd2leWQ2krQFVKks="
      # "sha256-YkOXzVxlEU22n1Zta7plAkvUEcPoTBXdGjew9Dl5vP0="
      "Fuchsia-Pop";

  programs = {
    zed-editor = {
      enable = false;
      userSettings = {
        vim_mode = true;
      };
    };
    zen-browser = {
      enable = true;
      policies =
        let
          mkExtensionSettings = builtins.mapAttrs (
            _: pluginId: {
              install_url = "https://addons.mozilla.org/firefox/downloads/file/${pluginId}/latest.xpi";
              installation_mode = "force_installed";
            }
          );
        in
        {
          AutofillAddressEnabled = false;
          AutofillCreditCardEnabled = false;
          DisableAppUpdate = true;
          DisableFeedbackCommands = true;
          DisableFirefoxStudies = true;
          DisablePocket = true;
          DisableTelemetry = true;
          DontCheckDefaultBrowser = true;
          NoDefaultBookmarks = true;
          OfferToSaveLogins = false;
          EnableTrackingProtection = {
            Value = true;
            Locked = true;
            Cryptomining = true;
            Fingerprinting = true;
          };
          SearchEngines = {
            Default = "DuckDuckGo";
          };
          ExtensionSettings = mkExtensionSettings {
            "{446900e4-71c2-419f-a6a7-df9c091e268b}" = "4562769"; # Bitwarden
            "uBlock0@raymondhill.net" = "4531307"; # uBlock Origin
            "addon@darkreader.org" = "4535824"; # Dark Reader
            "jid1-MnnxcxisBPnSXQ@jetpack" = "4504218"; # Privacy Badger
          };
        };
    };
  };

  dconf.enable = true;
  dconf.settings = {
    "org/gnome/desktop/peripherals/touchpad" = {
      natural-scroll = false;
    };
    "org/gnome/desktop/interface" = {
      accent-color = "red"; # Matches catppuccin blue accent
      # color-scheme = "default";  # Can be "default", "prefer-dark", or "prefer-light"
      # gtk-theme = "Matcha-dark-aliz";
    };
    "org/gnome/desktop/background" = {
      picture-uri = "file://${../../assets/wallpapers/a_house_with_snow_on_the_roof.jpg}";
      picture-uri-dark = "file://${../../assets/wallpapers/a_canal_between_buildings_with_boats.jpg}";
    };
    # "org/gnome/desktop/screensaver" = {
    #   picture-uri = "file://${../../assets/wallpapers/a_canal_between_buildings_with_boats.jpg}";
    #   primary-color = "#cdcdcd";
    #   secondary-color = "#1e1e1e;
    # };
    "org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = with pkgs.gnomeExtensions; [
        user-themes.extensionUuid
        caffeine.extensionUuid
        blur-my-shell.extensionUuid
      ];
    };
    # "org/gnome/shell/extensions/user-theme" = {
    #   name = "Matcha-dark-aliz";
    # };
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = [ "qemu:///system" ];
      uris = [ "qemu:///system" ];
    };
  };
}

{ lib, pkgs, config, ...}:
let
  nixGL = import ../../nix/nixGL.nix { inherit pkgs config; };
in
{
  imports = [];

  colors.theme = "catppuccin_frappe";

  home.file = {
    ".shelf/nvim.lua".text = ''
      local M = {}

      M.setup = function()
          -------------------
          --  THEME STUFF  --
          -------------------

          -- require("colors.catppuccin").config("frappe")
          vim.schedule(
            function()
              vim.api.nvim_set_option("background", "dark")
              require("colors.adwaita").config()
            end
          )

          ------------------------
          --  VIM CONFIG STUFF  --
          ------------------------

          vim.opt.wrap = false
          vim.g.nix = true
      end

      return M
    '';
  };

  home.packages = with pkgs; [
    speedcrunch
    prismlauncher
    # (catppuccin-kde.override {
    #   accents = [ "blue" ];
    #   flavour = [ "frappe" ];
    #   winDecStyles = [ "modern" "classic" ];
    # })
    gimp
    jellyfin-media-player
    logseq
    ollama
    meshcentral
    dig
    claude-code
  ];

  # Allow jellyfin-media-player to get controlled via mpris
  xdg.dataFile."jellyfinmediaplayer/scripts/mpris.so".source = "${pkgs.mpvScripts.mpris}/share/mpv/scripts/mpris.so";

  services = {
    syncthing = {
      enable = true;
    };
  };

  dotfiles.wm.hyprland = {
    enable = false;
    config = ''
      monitor=,preferred,auto,1
    '';
  };

  dotfiles.programs = {
    personal.enable = true;
    email.enable = true;
    browser.enable = true;
  };
  dotfiles.keyboard.enable = true;

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
      name = config.home.pointerCursor.name;
      package = config.home.pointerCursor.package;
      size = config.home.pointerCursor.size;
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "gtk3";
    style.name = "gtk2";
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
          name = name;
          size = 24;
          package = 
            pkgs.runCommand "moveUp" {} ''
              mkdir -p $out/share/icons
              ln -s ${pkgs.fetchzip {
                url = url;
                hash = hash;
              }} $out/share/icons/${name}
          '';
        };
    in
      getFrom 
        "https://github.com/ful1e5/fuchsia-cursor/releases/download/v2.0.1/Fuchsia-Pop.tar.xz"
        "sha256-rjeDa/hRZVOS8XeTWEG0Uzf3nTWPd2leWQ2krQFVKks="
        # "sha256-YkOXzVxlEU22n1Zta7plAkvUEcPoTBXdGjew9Dl5vP0="
        "Fuchsia-Pop";

  programs = {
    zed-editor = {
      enable = true;
      userSettings = {
        vim_mode = true;
      };
    };
    zen-browser = {
      enable = true;
      policies = {
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
      };
    };
  };

  dconf.enable = true;
  dconf.settings = {
    "org/gnome/desktop/peripherals/touchpad" = {
      natural-scroll = false;
    };
    "org/gnome/desktop/interface" = {
      accent-color = "red";  # Matches catppuccin blue accent
      color-scheme = "default";  # Can be "default", "prefer-dark", or "prefer-light"
      # gtk-theme = "Matcha-dark-aliz";
    };
    "org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = with pkgs.gnomeExtensions; [
        # keep-awake.extensionUuid
        user-themes.extensionUuid
        caffeine.extensionUuid
      ];
    };
    # "org/gnome/shell/extensions/user-theme" = {
    #   name = "Matcha-dark-aliz";
    # };
  };
  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
    };
  };
}

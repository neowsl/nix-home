{
  lib,
  pkgs,
  inputs,
  ...
}:

let
  awww = inputs.awww.packages.${pkgs.stdenv.hostPlatform.system}.default;
  zen = inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default;

  guiDirs = [
    "ghostty"
    "hypr"
    "neovide"
    "niri"
  ];
  mkConfig = name: {
    source = ../src + "/${name}";
    recursive = true;
  };
in
{
  imports = [
    inputs.dms.homeModules.default
  ];

  home = {
    file = builtins.listToAttrs (
      map (name: {
        name = ".config/${name}";
        value = mkConfig name;
      }) guiDirs
    );

    packages = [
      awww
      zen
    ]
    ++ (with pkgs; [
      android-file-transfer
      cloudflared
      godot
      grim
      grimblast
      hyprshot
      localsend
      networkmanagerapplet
      neovide
      nwg-displays
      pavucontrol
      piper
      polkit_gnome
      postman
      scrcpy
      showmethekey
      slurp
      system-config-printer
      uxplay
      vscodium
      way-displays
      wl-clipboard
    ]);

    pointerCursor = {
      gtk.enable = true;
      name = "Bibata-Modern-Classic";
      package = pkgs.bibata-cursors;
      size = 24;
      x11.enable = true;
    };

    sessionVariables = {
      DMS_HIDE_TRAYIDS = "nm-applet,blueman";
      MOZ_USE_XINPUT2 = "1";
      NIXOS_OZONE_WL = "1";
      PROTON_VERSION = "Proton Experimental";
      QT_STYLE_OVERRIDE = "kvantum";
    };
  };

  programs = {
    dank-material-shell = {
      enable = true;
      dgop.package = inputs.dgop.packages.${pkgs.stdenv.hostPlatform.system}.default;
    };
    ghostty.enable = true;
    hyprlock.enable = true;
    kitty = {
      enable = true;
      extraConfig = builtins.readFile ../src/kitty.conf;
    };
    obs-studio.enable = true;
    rofi = {
      enable = true;
      extraConfig = {
        disable-history = false;
        display-drun = "   Apps ";
        display-run = "   Run ";
        hide-scrollbar = true;
        icon-theme = "Papirus";
        location = 0;
        modi = "run,drun";
        show-icons = true;
        sidebar-mode = true;
      };
    };
    ssh = {
      enable = true;
      settings = {
        "minas-tirith" = {
          HostName = "192.168.1.12";
          User = "neo";
        };

        "attu" = {
          HostName = "attu.cs.washington.edu";
          User = "neo";

          ControlMaster = "auto";
          ControlPath = "~/.ssh/ans-%r@%h:%p";
          ControlPersist = "10m";
        };
      };
    };
    vscodium.enable = true;
    waybar = {
      enable = true;
      settings = {
        mainBar = {
          layer = "top";
          modules-left = [
            "custom/nixos"
            "hyprland/workspaces"
          ];
          modules-center = [ "clock" ];
          modules-right = [
            "battery"
            "pulseaudio"
            "tray"
          ];
          "custom/nixos" = {
            format = "<span size='x-large'></span> ";
            on-click = ''
              BG="$(find ~/Pictures/wallpapers -name '*.*' | shuf -n 1)" && awww img "$BG" --transition-type any
            '';
          };
          "hyprland/workspaces" = {
            format = "{icon}";
          };
          clock = {
            interval = 1;
            format = "{:%A • %Y-%m-%d • %H:%M:%S}";
          };
          battery = {
            interval = 1;
            format = " <span size='x-large'>{icon}</span> <span size='small' rise='4000'>{capacity} </span>";
            format-charging = " <span size='x-large'>󱐋</span> <span size='small' rise='4000'>{capacity} </span>";
            format-plugged = " <span size='x-large'></span> <span size='small' rise='4000'>{capacity} </span>";
            format-icons = [
              ""
              ""
              ""
              ""
              ""
            ];
            states = {
              warning = 30;
              critical = 15;
            };
          };
          pulseaudio = {
            format = " <span size='x-large'>{icon}</span> <span size='small' rise='4000'>{volume}</span>";
            format-muted = "󰖁";
            format-icons = {
              default = [
                ""
                ""
                ""
                ""
              ];
            };
            on-click = "pavucontrol &";
          };
          tray = {
            icon-size = 20;
            spacing = 6;
          };
        };
      };
      style = ../src/waybar.css;
    };
  };

  services = {
    dunst = {
      enable = true;
      settings = {
        global = {
          corner_radius = 10;
          font = "Ubuntu 12";
          frame_width = 2;
          offset = "8x8";
          width = 400;
        };
      };
    };
    udiskie.enable = true;
  };

  gtk = {
    enable = true;
    font = {
      name = "Ubuntu";
      size = 11;
    };
    iconTheme = {
      name = lib.mkForce "Papirus";
      package = lib.mkForce (
        pkgs.catppuccin-papirus-folders.override {
          flavor = "mocha";
          accent = "blue";
        }
      );
    };
    theme = {
      name = lib.mkForce "Colloid-Dark-Catppuccin";
      package = pkgs.colloid-gtk-theme.override {
        tweaks = [
          "catppuccin"
          "black"
          "rimless"
        ];
      };
    };
  };

  xdg = {
    configFile."mimeapps.list".force = true;
    mimeApps = {
      enable = true;
      associations.added = {
        "application/pdf" = [ "org.gnome.Evince.desktop" ];
      };
      defaultApplications = {
        "text/html" = [ "zen.desktop" ];
        "x-scheme-handler/http" = [ "zen.desktop" ];
        "x-scheme-handler/https" = [ "zen.desktop" ];
        "x-scheme-handler/about" = [ "zen.desktop" ];
        "x-scheme-handler/unknown" = [ "zen.desktop" ];
        "application/pdf" = [ "org.gnome.Evince.desktop" ];
      };
    };
  };

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.addons = with pkgs; [
      qt6Packages.fcitx5-chinese-addons
      fcitx5-gtk
      libpinyin
    ];
  };
}

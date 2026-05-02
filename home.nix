{
  config,
  pkgs,
  pkgs-unstable,
  inputs,
  ...
}:

let
  awww = inputs.awww.packages.${pkgs.stdenv.hostPlatform.system}.default;
  hashword = inputs.hashword.packages.${pkgs.stdenv.hostPlatform.system}.default;
  zen = inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default;

  patrick-hand = pkgs.callPackage ./lib/derivations/patrick-hand.nix { };

  packages = import ./lib/packages { inherit pkgs pkgs-unstable; } ++ [
    awww
    hashword
    zen
    patrick-hand
  ];
  # nix-gaming = import (builtins.fetchTarball "https://github.com/fufexan/nix-gaming/archive/master.tar.gz");
in
{
  imports = [
    inputs.dms.homeModules.default
    inputs.dms.homeModules.niri
    inputs.niri.homeModules.niri
  ];

  catppuccin = {
    accent = "lavender";

    bat.enable = true;
    btop.enable = true;
    dunst.enable = true;
    fish.enable = true;
    kitty.enable = true;
    starship.enable = true;
  };

  nix = {
    package = pkgs.nix;
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  home = {
    file =
      let
        # collect all directories under `src`
        srcContents = builtins.readDir ./src;
        configDirs = builtins.filter (
          name:
          srcContents.${name} == "directory"
          && !(pkgs.lib.hasPrefix "." name)
          && !(pkgs.lib.hasPrefix "_" name)
        ) (builtins.attrNames srcContents);

        mkConfig = name: {
          source = ./src + "/${name}";
          recursive = true;
        };
      in
      # map each config directory to an attribute set suitable for `file`
      (builtins.listToAttrs (
        map (name: {
          name = ".config/${name}";
          value = mkConfig name;
        }) configDirs
      ))
      // {
        ".face".source = ./src/.face;
        ".ghc" = mkConfig ".ghc";
        ".npmrc".source = ./src/.npmrc;

        # ".config/xilinx/nix.sh".text = ''
        #   INSTALL_DIR=$HOME/tools/Xilinx
        #   VERSION=2024.1
        # '';
      };
    homeDirectory = "/home/neo";
    keyboard.options = [ "caps:escape" ];
    inherit packages;
    pointerCursor = {
      gtk.enable = true;
      name = "Bibata-Modern-Classic";
      package = pkgs.bibata-cursors;
      size = 24;
      x11.enable = true;
    };
    sessionPath = [
      "$HOME/.bun/bin"
      "$HOME/.config/emacs/bin"
      "$HOME/.config/home-manager/bin"
      "$HOME/.npm-packages/bin"
      "$HOME/bin"
    ];
    sessionVariables = {
      BAT_THEME = "Catppuccin Mocha";
      DOOMDIR = "${config.home.homeDirectory}/.config/home-manager/src/doom";
      EDITOR = "nvim";
      MOZ_USE_XINPUT2 = "1";
      NIXOS_OZONE_WL = "1";
      PF_INFO = "ascii title os uptime pkgs wm shell editor";
      PROTON_VERSION = "Proton Experimental";
      QT_STYLE_OVERRIDE = "kvantum";
    };
    shellAliases = {
      ls = "eza --all --long --icons --git";
      vi = "nvim";
      vim = "vi";
      lg = "lazygit";
      nix-xilinx = "nix run gitlab:doronbehar/nix-xilinx#xilinx-shell";
      vivado = "nix run gitlab:doronbehar/nix-xilinx#vivado";
    };
    stateVersion = "25.11";
    username = "neo";
  };

  programs = {
    btop.enable = true;
    dank-material-shell = {
      enable = true;
      dgop.package = inputs.dgop.packages.${pkgs.stdenv.hostPlatform.system}.default;
      niri.enableSpawn = true;
    };
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    fish = {
      enable = true;
      package = pkgs-unstable.fish;
      functions = {
        fish_user_key_bindings = "fish_vi_key_bindings";
        fish_greeting = ''
          echo
          pfetch
        '';
        y = ''
          set tmp (mktemp -t "yazi-cwd.XXXXXX")
          yazi $argv --cwd-file="$tmp"
          if set cwd (command cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
            builtin cd -- "$cwd"
          end
          rm -f -- "$tmp"
        '';
      };
      shellAbbrs = {
        "-" = "cd -";
      };
      shellInit = ''
        direnv hook fish | source
      '';
    };
    ghostty = {
      enable = true;
      enableFishIntegration = true;
    };
    git = {
      enable = true;
      settings = {
        user = {
          name = "Neal Wang";
          email = "nealwang.sh@protonmail.com";
        };
        credential.helper = "store";
        init.defaultBranch = "main";
      };
    };
    gpg.enable = true;
    helix.enable = true;
    home-manager.enable = true;
    hyprlock.enable = true;
    kitty = {
      enable = true;
      extraConfig = builtins.readFile ./src/kitty.conf;
    };
    niri = {
      enable = true;
      package = pkgs.niri;
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
      theme = ./src/rofi.rasi;
    };
    starship = {
      enable = true;
      enableFishIntegration = true;
      settings = {
        add_newline = false;
        line_break = {
          disabled = true;
        };
      };
    };
    vscode = {
      enable = true;
      package = pkgs.vscodium;
      profiles.default.extensions = with pkgs.vscode-extensions; [
        catppuccin.catppuccin-vsc
        vscodevim.vim
      ];
    };
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
      style = ./src/waybar.css;
    };
    zoxide = {
      enable = true;
      options = [ "--cmd cd" ];
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
    # NOTE: useGrimAdapter is not in official release yet
    # flameshot = {
    #   enable = true;
    #   settings = {
    #     General = {
    #       useGrimAdapter = true;
    #     };
    #   };
    # };
    udiskie.enable = true;
  };

  systemd.user.sessionVariables = {
    DOOMDIR = "${config.home.homeDirectory}/.config/home-manager/src/doom";
  };

  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = builtins.readFile ./src/hypr/hyprland.conf;
    xwayland.enable = true;
  };

  fonts.fontconfig.enable = true;

  gtk = {
    enable = true;
    font = {
      name = "Ubuntu";
      size = 11;
    };
    iconTheme = {
      name = "Papirus";
      package = pkgs.catppuccin-papirus-folders.override {
        flavor = "mocha";
        accent = "blue";
      };
    };
    # theme = {
    #   name = "Colloid-Dark-Catppuccin";
    #   package = pkgs.colloid-gtk-theme.override {
    #     tweaks = [
    #       "catppuccin"
    #       "black"
    #       "rimless"
    #     ];
    #   };
    # };
  };

  xdg.mimeApps = {
    enable = true;
    associations.added = {
      "application/pdf" = [ "org.gnome.Evince.desktop" ];
    };
    defaultApplications = {
      # "text/html" = [ "firefox-developer-edition.desktop" ];
      # "text/html" = [ "brave.desktop" ];
      "text/html" = [ "zen.desktop" ];
      "x-scheme-handler/http" = [ "zen.desktop" ];
      "x-scheme-handler/https" = [ "zen.desktop" ];
      "x-scheme-handler/about" = [ "zen.desktop" ];
      "x-scheme-handler/unknown" = [ "zen.desktop" ];
      # "text/html" = [ "firefox.desktop" ];
      # "x-scheme-handler/http" = [ "firefox.desktop" ];
      # "x-scheme-handler/https" = [ "firefox.desktop" ];
      # "x-scheme-handler/about" = [ "firefox.desktop" ];
      # "x-scheme-handler/unknown" = [ "firefox.desktop" ];
      "application/pdf" = [ "org.gnome.Evince.desktop" ];
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

{
  pkgs,
  pkgsUnstable,
  hashword,
  zen-browser,
  ...
}:

let
  packages = import ./lib/packages { inherit pkgs pkgsUnstable; };
  patrick-hand = pkgs.callPackage ./lib/derivations/patrick-hand.nix { };
  # nix-gaming = import (builtins.fetchTarball "https://github.com/fufexan/nix-gaming/archive/master.tar.gz");
in
{
  nix = {
    package = pkgs.nix;
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  home = {
    file = {
      ".config/bat" = {
        source = ./src/bat;
        recursive = true;
      };
      ".config/ghostty" = {
        source = ./src/ghostty;
        recursive = true;
      };
      ".config/helix" = {
        source = ./src/helix;
        recursive = true;
      };
      ".config/hypr" = {
        source = ./src/hypr;
        recursive = true;
      };
      ".config/neovide" = {
        source = ./src/neovide;
        recursive = true;
      };
      ".config/nvim" = {
        source = ./src/nvim;
        recursive = true;
      };
      ".config/xkb" = {
        source = ./src/xkb;
        recursive = true;
      };
      ".config/yazi" = {
        source = ./src/yazi;
        recursive = true;
      };
      ".face".source = ./src/.face;
      ".ghc" = {
        source = ./src/.ghc;
        recursive = true;
      };
      ".npmrc".source = ./src/.npmrc;
      # ".config/xilinx/nix.sh".text = ''
      #   INSTALL_DIR=$HOME/tools/Xilinx
      #   VERSION=2024.1
      # '';
    };
    homeDirectory = "/home/neo";
    keyboard.options = [ "caps:escape" ];
    packages = packages ++ [
      hashword.packages.${pkgs.system}.default
      zen-browser.packages.${pkgs.system}.default
      patrick-hand
    ];
    pointerCursor = {
      gtk.enable = true;
      name = "Bibata-Modern-Classic";
      package = pkgs.bibata-cursors;
      size = 24;
      x11.enable = true;
    };
    sessionPath = [
      "$HOME/.bun/bin"
      "$HOME/.config/home-manager/bin"
      "$HOME/.npm-packages/bin"
      "$HOME/bin"
    ];
    sessionVariables = {
      BAT_THEME = "Catppuccin Mocha";
      EDITOR = "nvim";
      MOZ_USE_XINPUT2 = "1";
      NIXOS_OZONE_WL = "1";
      PF_INFO = "ascii title os uptime pkgs wm shell editor";
      PROTON_VERSION = "Proton Experimental";
      QT_STYLE_OVERRIDE = "kvantum";
    };
    shellAliases = {
      home = "vi ~/.config/home-manager";
      ls = "eza --all --long --icons --git";
      vi = "nvim";
      vim = "vi";
      lg = "lazygit";
      nix-xilinx = "nix run gitlab:doronbehar/nix-xilinx#xilinx-shell";
      vivado = "nix run gitlab:doronbehar/nix-xilinx#vivado";
    };
    stateVersion = "25.05";
    username = "neo";
  };

  # nixpkgs.config.allowUnfree = true;

  programs = {
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    fish = {
      enable = true;
      package = pkgsUnstable.fish;
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
      shellInit = "direnv hook fish | source";
    };
    ghostty = {
      enable = true;
      enableFishIntegration = true;
    };
    git = {
      enable = true;
      extraConfig = {
        credential.helper = "store";
        init.defaultBranch = "main";
      };
      userName = "Neal Wang";
      userEmail = "nealwang.sh@protonmail.com";
    };
    helix.enable = true;
    home-manager.enable = true;
    htop.enable = true;
    hyprlock.enable = true;
    kitty = {
      enable = true;
      extraConfig = builtins.readFile ./src/kitty.conf;
      package = pkgsUnstable.kitty;
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
      package = pkgs.rofi-wayland;
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
              BG="$(find ~/Pictures/wallpapers -name '*.*' | shuf -n 1)" && swww img "$BG" --transition-type any
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
          background = "#1e1e2e";
          corner_radius = 10;
          font = "Ubuntu 12";
          foreground = "#cdd6f4";
          frame_color = "#89b4fa";
          frame_width = 2;
          offset = "8x8";
          width = 400;
        };
        urgency_critical = {
          frame_color = "#f38ba8";
        };
        urgency_low = {
          frame_color = "#a6e3a1";
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
    theme = {
      name = "Colloid-Dark-Catppuccin";
      package = pkgs.colloid-gtk-theme.override {
        tweaks = [
          "catppuccin"
          "black"
          "rimless"
        ];
      };
    };
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
      "application/pdf" = [ "org.gnome.Evince.desktop" ];
    };
  };

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-chinese-addons
      fcitx5-gtk
      libpinyin
    ];
  };
}

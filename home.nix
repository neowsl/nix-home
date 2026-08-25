{
  config,
  pkgs,
  pkgs-unstable,
  inputs,
  ...
}:

let
  hashword = inputs.hashword.packages.${pkgs.stdenv.hostPlatform.system}.default;
in
{
  catppuccin = {
    enable = true;
    accent = "lavender";

    ghostty.enable = false;
    waybar.enable = false;
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
        # ignore GUI apps for headless configs
        guiDirs = [
          "ghostty"
          "hypr"
          "neovide"
          "niri"
        ];
        configDirs = builtins.filter (
          name: srcContents.${name} == "directory" && !(builtins.elem name ([ ".ghc" ] ++ guiDirs))
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
      };
    homeDirectory = "/home/neo";
    keyboard.options = [ "caps:escape" ];
    packages = [ hashword ];
    sessionPath = [
      "$HOME/.bun/bin"
      "$HOME/.config/emacs/bin"
      "$HOME/.config/home-manager/bin"
      "$HOME/.npm-packages/bin"
      "$HOME/bin"
    ];
    sessionVariables = {
      BAT_THEME = "Catppuccin Mocha";
      BIOME_BINARY = "${pkgs.biome}/bin/biome";
      DOOMDIR = "${config.home.homeDirectory}/.config/home-manager/src/doom";
      EDITOR = "nvim";
      PF_INFO = "ascii title os uptime pkgs wm shell editor";
    };
    shellAliases = {
      ls = "eza --all --long --icons --git";
      vi = "nvim";
      vim = "vi";
      lg = "lazygit";
      nix-xilinx = "nix run gitlab:doronbehar/nix-xilinx#xilinx-shell";
      vivado = "nix run gitlab:doronbehar/nix-xilinx#vivado";
    };
    stateVersion = "26.05";
    username = "neo";
  };

  programs = {
    btop.enable = true;
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    fish = {
      enable = true;
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
    home-manager.enable = true;
    neovim = {
      enable = true;
      package = pkgs-unstable.neovim-unwrapped;
      extraLuaPackages = ps: [ ps.magick ];
      extraPackages = [ pkgs.imagemagick ];
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
    zoxide = {
      enable = true;
      options = [ "--cmd cd" ];
    };
  };

  fonts.fontconfig.enable = true;

  systemd.user.sessionVariables = {
    DOOMDIR = "${config.home.homeDirectory}/.config/home-manager/src/doom";
  };
}

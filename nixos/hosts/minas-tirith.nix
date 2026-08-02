{
  pkgs,
  ...
}:

{
  imports = [ ../hardware-configuration.nix ];

  system.stateVersion = "26.05";

  nixpkgs.config.allowUnfree = true;

  nix.settings = {
    auto-optimise-store = true;
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  boot.loader = {
    efi.canTouchEfiVariables = true;
    systemd-boot.enable = true;
  };

  networking = {
    hostName = "minas-tirith";
    firewall = {
      enable = true;
      allowedTCPPorts = [ 53 ];
      allowedUDPPorts = [ 53 ];
    };
    networkmanager.enable = true;
  };

  i18n.defaultLocale = "en_GB.UTF-8";

  users = {
    defaultUserShell = pkgs.fish;
    users.neo = {
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "networkmanager"
      ];
      linger = true; # allow systemd services to linger
    };
  };

  services = {
    adguardhome = {
      enable = true;
      mutableSettings = true;
      settings = {
        dns = {
          upstream_dns = [
            "https://dns.quad9.net/dns-query"
            "https://cloudflare-dns.com/dns-query"
          ];
        };
      };
    };
    cloudflared = {
      enable = true;
      tunnels."876e057d-dd25-4e7a-89c8-f242719b4a6a" = {
        credentialsFile = "/etc/cloudflared/876e057d-dd25-4e7a-89c8-f242719b4a6a.json";
        default = "http_status:404";
        ingress = {
          "git.nealwang.dev" = "http://localhost:3001";
          "adguard.nealwang.dev" = "http://localhost:3000";
          "maelstrom.nealwang.dev" = "http://localhost:4000";
        };
      };
    };
    forgejo = {
      enable = true;
      database.type = "postgres";
      lfs.enable = true;
      dump.enable = true;
      settings = {
        server = {
          DOMAIN = "git.nealwang.dev";
          ROOT_URL = "https://git.nealwang.dev/";
          HTTP_PORT = 3001;
          DISABLE_SSH = true;
        };
        service.DISABLE_REGISTRATION = true;
        session.COOKIE_SECURE = true;
      };
    };
    fstrim.enable = true;
    gitea-actions-runner.instances.default = {
      enable = true;
      name = "gimli";
      url = "https://git.nealwang.dev";
      tokenFile = "/etc/nixos/secrets/forgejo-runner-token";
      labels = [ "mordor:docker://node:22-alpine" ];
    };
    openssh = {
      enable = true;
      settings = {
        PubkeyAuthentication = true;
        MaxAuthTries = 3;
        PasswordAuthentication = false;
        PermitRootLogin = "prohibit-password";
        TrustedUserCAKeys = "/etc/ssh/cloudflare-ca.pub";
        Macs = [
          "hmac-sha2-512-etm@openssh.com"
          "hmac-sha2-256-etm@openssh.com"
          "umac-128-etm@openssh.com"
          "hmac-sha2-512"
          "hmac-sha2-256"
        ];
      };
    };
    xserver = {
      enable = true;
      displayManager.startx.enable = true;
      windowManager.icewm.enable = true;
    };
  };

  hardware = {
    enableAllFirmware = true;
    graphics.enable = true;
  };

  virtualisation = {
    docker.enable = true;
    oci-containers = {
      backend = "docker";
      containers.git-pages = {
        # static sites all on port 4000
        image = "codeberg.org/git-pages/git-pages:latest";
        ports = [ "127.0.0.1:4000:3000" ];
        volumes = [ "/var/lib/git-pages/data:/app/data" ];
      };
    };
  };

  programs = {
    fish.enable = true;
    niri.enable = true;
  };

  environment.systemPackages = with pkgs; [
    git
  ];
}

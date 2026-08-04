{
  pkgs,
  lib,
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
    cloudflare-warp = {
      enable = true;
      openFirewall = true;
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

  systemd.services = {
    "cloudflared-tunnel-876e057d-dd25-4e7a-89c8-f242719b4a6a" = {
      restartIfChanged = false; # plain switches never touch the tunnel
      after = [ "adguardhome.service" ]; # don't start until DNS is up
      serviceConfig = {
        Restart = lib.mkForce "always";
        RestartSec = 5;
        StartLimitIntervalSec = 0; # never give up permanently
      };
    };
    forgejo-runner = {
      description = "Forgejo Actions Runner (gimli)";
      wants = [
        "network-online.target"
        "docker.service"
      ];
      after = [
        "network-online.target"
        "docker.service"
      ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.forgejo-runner}/bin/forgejo-runner daemon --config /etc/forgejo-runner/config.yaml";
        User = "root";
        Restart = "on-failure";
        RestartSec = 2;
        StateDirectory = "forgejo-runner";
        WorkingDirectory = "/var/lib/forgejo-runner";
      };
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

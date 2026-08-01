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
          "minas-tirith.nealwang.dev" = "ssh://localhost:22";
          "adguard.nealwang.dev" = "http://localhost:3000";
        };
      };
    };
    fstrim.enable = true;
    openssh = {
      enable = true;
      settings = {
        MaxAuthTries = 3;
        PasswordAuthentication = false;
        PermitRootLogin = "prohibit-password";
        TrustedUserCAKeys = "/etc/ssh/cloudflare-ca.pub";
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

  programs = {
    fish.enable = true;
    niri.enable = true;
  };

  environment.systemPackages = with pkgs; [
    git
  ];
}

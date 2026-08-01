{
  pkgs,
  ...
}:

{
  imports = [ ../hardware-configuration.nix ];

  system.stateVersion = "25.11";

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
    hostName = "edoras";
    firewall = {
      enable = true;
      # allowedTCPPorts = [ ];
      # allowedUDPPorts = [ ];
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
    openssh.enable = true;
    fstrim.enable = true;
    # tailscale.enable = true;
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

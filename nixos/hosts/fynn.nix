{
  pkgs,
  lib,
  ...
}:

{
  system.stateVersion = "25.05";

  nixpkgs.config.allowUnfree = true;

  nix.settings.auto-optimise-store = true;

  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      grub.enable = lib.mkForce false;
    };
  };

  networking = {
    firewall = {
      # enable = true;
      enable = false; # for uxplay
      allowedTCPPorts = [
        7000
        7001
        7100
      ];
      allowedUDPPorts = [
        6000
        6001
        7011
      ];
    };
    hostName = "fynn";
    networkmanager.enable = true;
    resolvconf.dnsExtensionMechanism = false;
  };

  time.timeZone = "America/Los_Angeles";

  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true;
  };

  users = {
    defaultUserShell = pkgs.fish;
    users.neo = {
      extraGroups = [
        "wheel"
        "networkmanager"
        "audio"
        "adbusers"
        "dialout"
      ];
      isNormalUser = true;
    };
  };

  services = {
    # https://taoa.io/posts/Setting-up-ipad-screen-mirroring-on-nixos
    avahi = {
      enable = true;
      nssmdns4 = true;
      publish = {
        enable = true;
        addresses = true;
        domain = true;
        userServices = true;
        workstation = true;
      };
    };
    blueman.enable = true;
    # sometimes stops working
    # fprintd = {
    #   enable = true;
    #   tod = {
    #     enable = true;
    #     driver = pkgs.libfprint-2-tod1-goodix;
    #   };
    # };
    gnome.gnome-keyring.enable = true;
    illum.enable = true;
    input-remapper.enable = true;
    logind = {
      lidSwitch = "suspend";
      powerKey = "suspend";
    };
    pipewire = {
      alsa = {
        enable = true;
        support32Bit = true;
      };
      enable = true;
      pulse.enable = true;
    };
    postgresql = {
      enable = true;
      authentication = lib.mkForce ''
        # Generated file; do not edit!
        # TYPE  DATABASE        USER            ADDRESS                 METHOD
        local   all             all                                     trust
        host    all             all             127.0.0.1/32            trust
        host    all             all             ::1/128                 trust
      '';
    };
    ratbagd.enable = true;
    tlp = {
      enable = true;
      settings = {
        START_CHARGE_THRESH_BAT0 = 40;
        STOP_CHARGE_THRESH_BAT0 = 80;
        # START_CHARGE_THRESH_BAT0 = 99;
        # STOP_CHARGE_THRESH_BAT0 = 100;
      };
    };
    udev = {
      extraRules = ''
        SUBSYSTEM=="usb", ATTRS{idVendor}=="0d28", ATTRS{idProduct}=="0204", MODE="0666"
      '';
      packages = with pkgs; [
        android-udev-rules
        platformio-core
        libwacom
        (writeTextFile {
          name = "52-xilinx-digilent-usb.rules";
          text = ''
            ATTR{idVendor}=="1443", MODE:="666"
            ACTION=="add", ATTR{idVendor}=="0403", ATTR{manufacturer}=="Digilent", MODE:="666"
          '';

          destination = "/etc/udev/rules.d/52-xilinx-digilent-usb.rules";
        })
        (writeTextFile {
          name = "52-xilinx-ftdi-usb.rules";
          text = ''
            ACTION=="add", ATTR{idVendor}=="0403", ATTR{manufacturer}=="Xilinx", MODE:="666"
          '';

          destination = "/etc/udev/rules.d/52-xilinx-ftdi-usb.rules";
        })
        (writeTextFile {
          name = "52-xilinx-pcusb.rules";
          text = ''
            ATTR{idVendor}=="03fd", ATTR{idProduct}=="0008", MODE="666"
            ATTR{idVendor}=="03fd", ATTR{idProduct}=="0007", MODE="666"
            ATTR{idVendor}=="03fd", ATTR{idProduct}=="0009", MODE="666"
            ATTR{idVendor}=="03fd", ATTR{idProduct}=="000d", MODE="666"
            ATTR{idVendor}=="03fd", ATTR{idProduct}=="000f", MODE="666"
            ATTR{idVendor}=="03fd", ATTR{idProduct}=="0013", MODE="666"
            ATTR{idVendor}=="03fd", ATTR{idProduct}=="0015", MODE="666"
          '';

          destination = "/etc/udev/rules.d/52-xilinx-pcusb.rules";
        })
      ];
    };
    udisks2.enable = true;
    upower.enable = true;
    xserver = {
      displayManager.startx.enable = true;
      enable = true;
      xkb = {
        options = "caps:swapescape";
        # variant = "dvorak";
      };
    };
  };

  security = {
    pam.services = {
      hyprlock = { };
      # login.kwallet.forceRun = true;
      login.enableGnomeKeyring = true;
    };
    polkit.enable = true;
    rtkit.enable = true;
  };

  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    graphics.enable32Bit = true;
    opentabletdriver.enable = true;
  };

  environment.systemPackages = with pkgs; [ git ];

  programs = {
    dconf.enable = true;
    fish.enable = true;
  };

  # systemd.sleep.extraConfig = ''
  #   HibernateDelaySec=30m
  # '';

  gtk.iconCache.enable = true;

  xdg.portal = {
    enable = true;
    config.common.default = "*";
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
    ];
  };

  i18n.defaultLocale = "en_GB.UTF-8";
}

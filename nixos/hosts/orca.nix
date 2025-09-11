{ config, pkgs, lib, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  boot = {
    kernelPackages = pkgs.linuxPackages_5_4;
    blacklistedKernelModules = [ "rtl8xxxu" ];
    extraModulePackages = [ config.boot.kernelPackages.rtl88x2bu ];
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = true;
    };
  };

  nix.autoOptimiseStore = true;

  networking = {
    firewall = {
      enable = true;
      allowedTCPPorts = [ 3000 8080 ];
    };
    hostName = "fynn";
    networkmanager.enable = true;
  };

  time.timeZone = "America/Los_Angeles";

  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true;
  };

  users = {
    defaultUserShell = pkgs.fish;
    users.neo = {
      extraGroups = [ "wheel" "networkmanager" "audio" "vboxusers" ];
      isNormalUser = true;
    };
  };

  services = {
    openssh.enable = true;
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
    udev.packages = [ pkgs.libwacom ];
    udisks2.enable = true;
    xserver = {
      enable = true;
      digimend.enable = true;
      displayManager = {
        autoLogin.enable = true;
        autoLogin.user = "neo";
        setupCommands = "${pkgs.xorg.xrandr}/bin/xrandr --output HDMI-1 --primary --mode 1920x1080 --left-of VGA-1";
      };
      gdk-pixbuf.modulePackages = with pkgs; [ librsvg ];
      wacom.enable = true;
      windowManager.xmonad.enable = true;
      xkbOptions = "caps:escape";
    };
  };

  gtk.iconCache.enable = true;

  sound.enable = true;

  hardware = {
    opengl.driSupport32Bit = true;
    pulseaudio.enable = true;
  };

  environment.systemPackages = with pkgs; [ neovim ];

  programs = {
    dconf.enable = true;
    fish.enable = true;
    slock.enable = true;
  };

  i18n.inputMethod = {
    enabled = "ibus";
    ibus.engines = with pkgs.ibus-engines; [ libpinyin ];
  };

  virtualisation.virtualbox.host.enable = true;

  system.stateVersion = "23.11";
}

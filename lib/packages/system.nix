{ pkgs, pkgs-unstable }:

# system utilities
with pkgs;
[
  alsa-utils
  android-file-transfer
  appimage-run
  fswatch
  grim
  grimblast
  hunspell
  hunspellDicts.en_GB-ise
  hyprshot
  inotify-tools
  libsecret
  libtool
  localsend
  # lxqt.lxqt-policykit
  networkmanagerapplet
  notify-desktop
  nwg-displays
  openconnect
  pavucontrol
  piper
  polkit_gnome
  slurp
  system-config-printer
  way-displays
  wget
]

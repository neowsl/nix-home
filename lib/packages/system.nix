{ pkgs, pkgs-unstable }:

# system utilities
# GUI-only tools live in `modules/desktop.nix`
with pkgs;
[
  alsa-utils
  appimage-run
  fswatch
  hunspell
  hunspellDicts.en_GB-ise
  inotify-tools
  libsecret
  libtool
  notify-desktop
  openconnect
  wget
]

{ pkgs, pkgs-unstable }:

# non-development apps
with pkgs;
[
  art
  audacity
  chromium
  dl-librescore
  pkgs-unstable.electron-mail
  evince
  firefox-bin
  foliate
  gimp3
  inkscape
  kdePackages.kdenlive
  krita
  pkgs-unstable.legcord
  libqalculate
  libreoffice-qt
  libresprite
  musescore
  obsidian
  qalculate-gtk
  seahorse
  steam
  vlc
  (thunar.override {
    thunarPlugins = [
      file-roller
      thunar-archive-plugin
      thunar-dropbox-plugin
      tumbler
    ];
  })
  zotero
]

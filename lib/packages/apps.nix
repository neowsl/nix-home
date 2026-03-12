{ pkgs, pkgs-unstable }:

with pkgs;
[
  art
  audacity
  blender
  brave
  dl-librescore
  pkgs-unstable.electron-mail
  evince
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
  (xfce.thunar.override {
    thunarPlugins = [
      file-roller
      xfce.thunar-archive-plugin
      xfce.thunar-dropbox-plugin
      xfce.tumbler
    ];
  })
  yazi
  zotero
]

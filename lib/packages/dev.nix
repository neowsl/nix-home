{ pkgs, pkgsUnstable }:

with pkgs;
[
  arduino-ide
  cmake
  gnumake
  godot
  just
  lazygit
  neovide
  pkgsUnstable.neovim
  ninja
  postman
  sccache
  scrcpy
  showmethekey
  tree-sitter
  uxplay
  websocat
  wl-clipboard
]

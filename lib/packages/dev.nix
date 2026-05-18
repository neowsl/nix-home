{ pkgs, pkgs-unstable }:

# general development tools
# language-specific tools go in `./langs.nix`
with pkgs;
[
  cmake
  emacs-pgtk
  gnumake
  godot
  just
  lazygit
  neovide
  postman
  sccache
  scrcpy
  showmethekey
  tree-sitter
  uv
  uxplay
  vim-full
  websocat
  wl-clipboard
]

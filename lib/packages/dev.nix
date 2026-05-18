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
  pkgs-unstable.neovim
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

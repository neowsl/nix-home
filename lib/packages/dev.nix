{ pkgs, pkgs-unstable }:

# general development tools
# language-specific tools go in `./langs.nix`
# GUI-only tools live in `modules/desktop.nix`
with pkgs;
[
  cmake
  emacs-pgtk
  gnumake
  just
  lazygit
  opencode
  sccache
  tree-sitter
  uv
  vim-full
  websocat
]

{ pkgs, pkgs-unstable }:

# general development tools
# language-specific tools go in `./langs.nix`
# GUI-only tools live in `modules/desktop.nix`
let
  lspBridgeEnv = pkgs.python3.withPackages (
    ps: with ps; [
      epc
      orjson
      sexpdata
      six
      paramiko
      rapidfuzz
      watchdog
      setuptools
      packaging
    ]
  );
in
with pkgs;
[
  cmake
  gnumake
  just
  lazygit
  libqalculate
  lspBridgeEnv
  pkgs-unstable.opencode
  sccache
  tree-sitter
  uv
  vim-full
  websocat
]

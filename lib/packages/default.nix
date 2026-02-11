{ pkgs, pkgs-unstable }:

let
  apps = import ./apps.nix { inherit pkgs pkgs-unstable; };
  cli = import ./cli.nix { inherit pkgs pkgs-unstable; };
  dev = import ./dev.nix { inherit pkgs pkgs-unstable; };
  fonts = import ./fonts.nix { inherit pkgs pkgs-unstable; };
  fun = import ./fun.nix { inherit pkgs pkgs-unstable; };
  langs = import ./langs.nix { inherit pkgs pkgs-unstable; };
  system = import ./system.nix { inherit pkgs pkgs-unstable; };
in
apps ++ cli ++ dev ++ fonts ++ fun ++ langs ++ system

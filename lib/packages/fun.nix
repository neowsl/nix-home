{ pkgs, pkgs-unstable }:

with pkgs;
[
  pkgs-unstable.airshipper
  asciiquarium
  blanket
  cmatrix
  heroic
  # nix-gaming.packages.${pkgs.hostPlatform.system}.wine-ge
  oneko
  pfetch
  pipes
  pkgs-unstable.prismlauncher
  tty-clock
]

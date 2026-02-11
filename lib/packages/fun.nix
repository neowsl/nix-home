{ pkgs, pkgs-unstable }:

with pkgs;
[
  pkgs-unstable.airshipper
  asciiquarium
  blanket
  cmatrix
  # nix-gaming.packages.${pkgs.hostPlatform.system}.wine-ge
  oneko
  pfetch
  pipes
  tty-clock
]

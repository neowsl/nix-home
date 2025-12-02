{ pkgs, pkgsUnstable }:

with pkgs;
[
  pkgsUnstable.airshipper
  asciiquarium
  blanket
  cmatrix
  # nix-gaming.packages.${pkgs.hostPlatform.system}.wine-ge
  oneko
  pfetch
  pipes
  tty-clock
]

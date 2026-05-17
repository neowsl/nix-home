{ pkgs, pkgs-unstable }:

# games and cool/interesting apps
with pkgs;
[
  asciiquarium-transparent
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

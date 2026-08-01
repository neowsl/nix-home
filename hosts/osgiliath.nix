{ pkgsets, ... }:

{
  home.packages = pkgsets.cli ++ pkgsets.dev ++ pkgsets.fonts ++ pkgsets.langs;
}

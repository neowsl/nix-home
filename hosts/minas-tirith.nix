{ pkgsets, ... }:

{
  home.packages = pkgsets.cli ++ pkgsets.dev ++ pkgsets.langs;
}

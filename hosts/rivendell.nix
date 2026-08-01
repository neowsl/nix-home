{ pkgsets, ... }:

{
  home.packages =
    pkgsets.apps
    ++ pkgsets.cli
    ++ pkgsets.dev
    ++ pkgsets.fonts
    ++ pkgsets.fun
    ++ pkgsets.langs
    ++ pkgsets.system;
}

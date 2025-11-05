{ pkgs }:

pkgs.stdenvNoCC.mkDerivation {
  pname = "patrick-hand";
  version = "1";

  src = pkgs.fetchurl {
    url = "https://github.com/google/fonts/raw/main/ofl/patrickhand/PatrickHand-Regular.ttf";
    sha256 = "1z6h9bpngs8pp2dldc4jk4gy2kmcqmbh0zxzp8jszldndhz3n5qg";
  };

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/share/fonts/truetype
    cp $src $out/share/fonts/truetype/
  '';

  meta = {
    description = "Patrick Hand font";
    homepage = "https://fonts.google.com/specimen/Patrick+Hand";
    license = pkgs.lib.licenses.ofl;
  };
}

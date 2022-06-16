{ pkgs ? import <nixpkgs> {}
}:

pkgs.mkDerivation {
  src = pkgs.fetchFromGitHub {
    owner = "ceuk";
    repo = "rofi-screenshot";
    rev = "050c3ebb84c887158eed492bfc5f34f9f139a34a";
    sha256 = "1ny57f8cr4as1f3dcz7sfnclgrp7bvq1g0lvccbjmkv9zr90gcsa";
  };
  buildInputs = [ ffcast rofi slop xclip ];
}
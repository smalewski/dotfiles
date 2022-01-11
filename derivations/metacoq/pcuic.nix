{ lib, mkCoqDerivation, version ? null
, equations, template, which, zarith }:

mkCoqDerivation {
  pname = "pcuic";
  owner = "MetaCoq";
  repo = "metacoq";
  inherit version;
  defaultVersion = "8.14"; /* with versions; switch coq.coq-version [
    { case = "8.14"; out = "8.14"; }
  ] null;
*/

  release."8.14".rev = "0fcd333224dc139f16f44f9ef6b53e752ecd9f32";
  release."8.14".sha256 = "1ny57f8cr4as1f3dcz7sfnclgrp7bvq1g0lvccbjmkv9zr90gcsa";

  mlPlugin = true;

  nativeBuildInputs = [ which ];
  extraBuildInputs = [ equations template zarith ];

  preBuild = ''
    cd pcuic
    touch metacoq-config
    patchShebangs clean_extraction.sh
    patchShebangs theories/replace.sh
  '';

  meta = {
    homepage = "https://github.com/MetaCoq/metacoq/";
    description = "metacoq";
    maintainers = [];
  };
}

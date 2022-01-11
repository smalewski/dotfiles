{ lib, mkCoqDerivation, version ? null
, coq, equations, which , template, checker, rev, sha256, zarith
}:

let
  templateSrc = "-I ${template}/lib/coq/${coq.coq-version}/user-contrib/MetaCoq/Template/";
  checkerSrc = "-I ${checker}/lib/coq/${coq.coq-version}/user-contrib/MetaCoq/Checker/";
in
with lib; mkCoqDerivation {
  pname = "pcuic";
  owner = "TheoWinterhalter";
  repo = "template-coq";
  inherit version;
  defaultVersion = "rewrite";

  release."rewrite".rev = rev;
  release."rewrite".sha256 = sha256;

  mlPlugin = true;
  patchFlags = [ "-c" "-p0" ];
  patches = [ ./patches/pcuic.patch ];

  nativeBuildInputs = [ which ];
  extraBuildInputs = [ equations zarith template checker ];
  preBuild = ''
    cd pcuic
    echo "${templateSrc}" >> metacoq-config
    echo "${checkerSrc}" >> metacoq-config
    patchShebangs clean_extraction.sh
  '';

  meta = {
    homepage = "https://github.com/MetaCoq/metacoq/";
    description = "metacoq";
    maintainers = [];
  };
}

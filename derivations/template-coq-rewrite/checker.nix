{ lib, mkCoqDerivation, version ? null
, coq, equations, which, zarith
, template, rev, sha256
}:

let
  templateSrc = "-I ${template}/lib/coq/${coq.coq-version}/user-contrib/MetaCoq/Template";
in
with lib; mkCoqDerivation {
  pname = "checker";
  owner = "TheoWinterhalter";
  repo = "template-coq";
  inherit version;
  defaultVersion = "rewrite";

  release."rewrite".rev = rev;
  release."rewrite".sha256 = sha256;

  mlPlugin = true;
  patchFlags = [ "-c" "-p0" ];
  patches = [ ./patches/checker.patch ];

  nativeBuildInputs = [ which ];
  extraBuildInputs = [ equations zarith template ];
  preBuild = ''
    cd checker
    patchShebangs update_plugin.sh
    sed -i "1c ${templateSrc}" _CoqProject.in
    touch metacoq-config
  '';



  meta = {
    homepage = "https://github.com/MetaCoq/metacoq/";
    description = "metacoq";
    maintainers = [];
  };
}

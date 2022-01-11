{ mkCoqDerivation, version ? null
, coq, which, rev, sha256
}:

mkCoqDerivation {
  pname = "template-coq";
  owner = "TheoWinterhalter";
  repo = "template-coq";
  inherit version;
  defaultVersion = "rewrite";

  release."rewrite".rev = rev;
  release."rewrite".sha256 = sha256;

  mlPlugin = true;
  nativeBuildInputs = [ which ];
  COQLIB = "${coq}/lib/coq/";

  preBuild = ''
    cd template-coq
    patchShebangs update_plugin.sh
  '';
}

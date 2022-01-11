self: super:

let
  coq = super.callPackage ./default.nix {
    inherit (self)
      ocamlPackages_4_05
      ocamlPackages_4_09
      ocamlPackages_4_10
      ocamlPackages_4_12;
    version = "8.11.0";
    customOCamlPackages = self.ocaml-ng.ocamlPackages_4_07;
  };
  coqPackages =
    (self.mkCoqPackages coq).overrideScope' (selfh: superh: {
      equations = superh.mkCoqDerivation {
        pname = "equations";
        version = "1.2.1+coq8.11";
        owner = "mattam82";
        repo = "Coq-Equations";

        release."1.2.1+coq8.11".rev = "136e2babe0399867ed4ddc2e89857d773bc92ddb";
        release."1.2.1+coq8.11".sha256 = "06k0h7lansxs479is3vj5ikg8s5k4c6svnqcwmxbni4wx8bhmg17";

        mlPlugin = true;
        preBuild = "coq_makefile -f _CoqProject -o Makefile";
      };
    });
in
{
  coqPackages_8_11_0 = coqPackages;
}

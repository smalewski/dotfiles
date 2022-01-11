let
  rev = "10304b441a52a092369d3d9bc6663a9785cd581e";
  sha256 = "0qzkdll8n3xmcqf556mvilflpfgdk0ahcfjx2scjalvcjldn32d4";

  coqOverlay = import ./coq/overlay.nix;
  pkgs = import <nixpkgs> { overlays = [ coqOverlay ]; };
  coqPackages = pkgs.coqPackages_8_11_0;
  ocamlPackages = coqPackages.coq.ocamlPackages;

  deps = {
    inherit rev sha256;
    inherit (coqPackages) coq equations mkCoqDerivation;
    inherit (ocamlPackages) zarith;
  };
  callPackage = pkgs.lib.callPackageWith (pkgs // deps // self);
  self = {
    template = callPackage ./template-coq.nix {};
    checker = callPackage ./checker.nix {};
    pcuic = callPackage ./pcuic.nix {};
  };
in self

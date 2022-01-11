let
  pkgs = import <nixpkgs> {};
  metacoq = import ./default.nix;
  inherit (metacoq) template checker pcuic;
in
pkgs.mkShell {
  buildInputs = [ metacoq ];
}

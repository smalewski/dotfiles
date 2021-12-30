{ pkgs }:

let
  home-manager = builtins.fetchFromGitHub {
    owner = "nix-community";
    repo = "home-manager";
    rev = "697cc8c68ed6a606296efbbe9614c32537078756";
    sha256 ="1c8gxm86zshr2zj9dvr02qs7y3m46gqavr6wyv01r09jfd99dxz9";
  };

  evalHome = import "${toString home-manager}/modules";
in
{
  home-config = pkgs.lib.recurseIntoAttrs (
    evalHome {
      configuration = ./home.nix;
      lib = pkgs.lib;
      pkgs = pkgs;
    }
  );

  # Allow nix to recurse into this attribute set to look for derivations
  recurseForDerivations = true;
}

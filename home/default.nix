{ pkgs }:

let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/master.tar.gz";

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

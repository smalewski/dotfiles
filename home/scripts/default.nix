{ config, pkgs, ... }:

let
  hms = pkgs.callPackage ./switcher.nix { inherit config pkgs; };
  doom-reload = pkgs.callPackage ./doom-reload.nix { inherit config pkgs; };
in
[
  hms         # custom home-manager switcher that considers the current DISPLAY
  doom-reload # recompiles doom-emacs on change
]

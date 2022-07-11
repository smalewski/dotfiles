{ config, pkgs, ... }:

let
  hms = pkgs.callPackage ./switcher.nix { inherit config pkgs; };
  doom-reload = pkgs.callPackage ./doom-reload.nix { inherit config pkgs; };
  rofi-monitor-layout = pkgs.writeShellScriptBin "rofi-monitor-layout" (builtins.readFile ./monitor_layout.sh);
in
[
  hms # custom home-manager switcher that considers the current DISPLAY
  doom-reload # recompiles doom-emacs on change
  rofi-monitor-layout
]

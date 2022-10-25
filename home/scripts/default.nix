{ config, pkgs, ... }:

let
  rofi-monitor-layout = pkgs.writeShellScriptBin "rofi-monitor-layout" (builtins.readFile ./monitor_layout.sh);
in
[
  rofi-monitor-layout
]

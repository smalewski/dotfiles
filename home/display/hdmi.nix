# Configuration for the HDMI-1 display monitor
{ config, lib, pkgs, stdenv, ... }:

let
  base = pkgs.callPackage ../home.nix { inherit config lib pkgs stdenv; };

  #browser = pkgs.callPackage ../programs/browsers/firefox.nix {
  #inherit config pkgs;
  #inherit (pkgs) nur;
  #hdmiOn = true;
  #dpOn = false;
  #};

  terminal = import ../programs/alacritty/default.nix { fontSize = 10; inherit pkgs; };

  wm = import ../programs/xmonad/default.nix {
    inherit config pkgs lib;
    hdmiOn = true;
  };
in
{
  imports = [
    ../home.nix
    terminal
    wm
  ];

  #programs.firefox = browser.programs.firefox;

  home.packages = base.home.packages;
}

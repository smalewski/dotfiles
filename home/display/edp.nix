# Configuration for the eDP display of the Tongfang laptop (default: HDMI-1)
{ config, lib, pkgs, stdenv, ... }:

let
  base = pkgs.callPackage ../home.nix { inherit config lib pkgs stdenv; };

  #browser = pkgs.callPackage ../programs/browsers/firefox.nix {
  #inherit config pkgs;
  #inherit (pkgs) nur;
  #hdmiOn = false;
  #dpOn = false;
  #};

  terminal = import ../programs/alacritty/default.nix { fontSize = 8; inherit pkgs; };

  wm = import ../programs/xmonad/default.nix {
    inherit config pkgs lib;
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

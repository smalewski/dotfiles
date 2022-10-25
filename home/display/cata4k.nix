# Configuration for the DP-2-1
{ config, lib, pkgs, stdenv, ... }:

let
  base = pkgs.callPackage ../home.nix { inherit config lib pkgs stdenv; };

  #browser = pkgs.callPackage ../programs/browsers/firefox.nix {
  #inherit config pkgs;
  #inherit (pkgs) nur;
  #hdmiOn = false;
  #dpOn = true;
  #};

  hdmiBar = pkgs.callPackage ../services/polybar/bar.nix { };

  statusBar = import ../services/polybar/default.nix {
    inherit config pkgs;
    mainBar = hdmiBar;
    openCalendar = "";
  };

  terminal = import ../programs/alacritty/default.nix { fontSize = 10; inherit pkgs; };

  wm = import ../programs/xmonad/default.nix {
    inherit config pkgs lib;
    cata4kOn = true;
  };
in
{
  imports = [
    ../home.nix
    statusBar
    terminal
    wm
  ];

  #programs.firefox = browser.programs.firefox;

  home.packages = base.home.packages;
}

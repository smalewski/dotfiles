# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  imports =
    [
      ./../../configuration.nix
      ./hardware-configuration.nix
    ];

  networking.hostName = "lembook-T460";
  system.stateVersion = "21.11";
}


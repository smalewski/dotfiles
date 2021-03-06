{ pkgs, lib,
  hdmiOn ? false,
  dpOn ? false,
  cata4kOn ? false,
  ... }:

let
  extra = ''
    ${pkgs.util-linux}/bin/setterm -blank 0 -powersave off -powerdown 0
    ${pkgs.xorg.xset}/bin/xset s off
    ${pkgs.xcape}/bin/xcape -e "Hyper_L=Tab;Hyper_R=backslash"
  '';

  hdmiExtra = ''
    ${pkgs.xorg.xrandr}/bin/xrandr --output HDMI-2 --mode 1920x1080 --rate 60.00
  '';

  dpExtra = ''
    ${pkgs.xorg.xrandr}/bin/xrandr --output DP-2-2 --mode 2560x1440
  '';

  cata4kExtra = ''
    ${pkgs.xorg.xrandr}/bin/xrandr --output DP-2-1 --mode 1920x1080
  '';

#    ${pkgs.nitrogen}/bin/nitrogen --restore &
  polybarOpts = ''
    ${pkgs.pasystray}/bin/pasystray &
    ${pkgs.blueman}/bin/blueman-applet &
    ${pkgs.gnome3.networkmanagerapplet}/bin/nm-applet --sm-disable --indicator &
  '';

in
{
  xresources.properties = {
    "Xft.dpi" = 180;
    "Xft.autohint" = 0;
    "Xft.hintstyle" = "hintfull";
    "Xft.hinting" = 1;
    "Xft.antialias" = 1;
    "Xft.rgba" = "rgb";
    "Xcursor*theme" = "Vanilla-DMZ-AA";
    "Xcursor*size" = 24;
  };

  xsession = {
    enable = true;

    initExtra = extra + polybarOpts +
                lib.optionalString hdmiOn hdmiExtra +
                lib.optionalString dpOn dpExtra +
                lib.optionalString cata4kOn cata4kExtra;

    windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
      extraPackages = hp: [
        hp.dbus
        hp.monad-logger
      ];
      config = ./config.hs;
    };
  };
}

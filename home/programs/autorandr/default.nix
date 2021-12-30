{ pkgs, ... }:

let
  # obtained via `autorandr --fingerprint`
  t27pId = "00ffffffffffff0030aee96100000000161e0104a53c22783e6665a9544c9d26105054a1080081c0810081809500a9c0b300d1c00101565e00a0a0a0295030203500615d2100001a000000fc00503237682d32300a2020202020000000fd00324c1e5a24000a202020202020000000ff00563930363639434b0affffffff01f7020318f14b9005040302011f13140e0f23090f0783010000662156aa51001e30468f33000f282100001eab22a0a050841a30302036000f282100001c7c2e90a0601a1e40302036000f282100001c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000006a";
  robo03Id = "00ffffffffffff0010ac9ca04c3135351219010380351e78eaa0a5a656529d270f5054a54b00714f8180a9c0d1c00101010101010101023a801871382d40582c45000f292100001e000000ff003532344e333535323535314c0a000000fc0044454c4c205032343134480a20000000fd00384c1e5311000a202020202020019c02031b61230907078301000067030c002000802d43908402e2000f8c0ad08a20e02d10103e9600a05a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000029";
  laptopScreenId = "00ffffffffffff000dae90140000000028170104951f1178027e45935553942823505400000001010101010101010101010101010101da1d56e250002030442d470035ad10000018000000fe004e3134304247452d4541330a20000000fe00434d4e0a202020202020202020000000fe004e3134304247452d4541330a20007e";

  notify = "${pkgs.libnotify}/bin/notify-send";
in
{
  programs.autorandr = {
    enable = true;

    hooks = {
      predetect = {};

      preswitch = {};

      postswitch = {
        "notify-xmonad" = ''
          ${notify} -i display "Display profile" "$AUTORANDR_CURRENT_PROFILE"
        '';

        "change-dpi" = ''
          case "$AUTORANDR_CURRENT_PROFILE" in
            away)
              DPI=120
              ;;
            dcc)
              DPI=120
              ;;
            home)
              DPI=108
              ;;
            *)
              ${notify} -i display "Unknown profle: $AUTORANDR_CURRENT_PROFILE"
              exit 1
          esac

          echo "Xft.dpi: $DPI" | ${pkgs.xorg.xrdb}/bin/xrdb -merge
        '';
      };
    };

    profiles = {
      "away" = {
        fingerprint = {
          eDP-1 = laptopScreenId;
        };

        config = {
          eDP-1 = {
            enable = true;
            crtc = 0;
            primary = true;
            position = "0x0";
            mode = "1366x768";
            rate = "60.00";
            rotate = "normal";
          };
        };
      };

      "dcc" = {
        fingerprint = {
          HDMI-2 = robo03Id;
          eDP-1 = laptopScreenId;
        };

        config = {
          HDMI-2 = {
            enable = true;
            crtc = 0;
            primary = true;
            position = "0x0";
            mode = "1920x1080";
            rate = "60.00";
          };
          eDP-1 = {
            enable = true;
            crtc = 1;
            position = "1920x0";
            mode = "1366x768";
            rate = "60.00";
            rotate = "normal";
          };
        };
      };

      "home" = {
        fingerprint = {
          DP-2-2 = t27pId;
          eDP-1 = laptopScreenId;
        };

        config = {
          DP-2-2 = {
            enable = true;
            crtc = 0;
            primary = true;
            position = "0x0";
            mode = "2560x1440";
          };
          eDP-1 = {
            enable = true;
            crtc = 1;
            position = "2560x0";
            mode = "1366x768";
            rotate = "normal";
          };
        };
      };
    };

  };
}

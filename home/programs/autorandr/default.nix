{ pkgs, ... }:

let
  # obtained via `autorandr --fingerprint`
  t27pId = "00ffffffffffff0030aee96100000000161e0104a53c22783e6665a9544c9d26105054a1080081c0810081809500a9c0b300d1c00101565e00a0a0a0295030203500615d2100001a000000fc00503237682d32300a2020202020000000fd00324c1e5a24000a202020202020000000ff00563930363639434b0affffffff01f7020318f14b9005040302011f13140e0f23090f0783010000662156aa51001e30468f33000f282100001eab22a0a050841a30302036000f282100001c7c2e90a0601a1e40302036000f282100001c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000006a";
  laptopScreenId = "00ffffffffffff000dae90140000000028170104951f1178027e45935553942823505400000001010101010101010101010101010101da1d56e250002030442d470035ad10000018000000fe004e3134304247452d4541330a20000000fe00434d4e0a202020202020202020000000fe004e3134304247452d4541330a20007e";
  cataScreenId = "00ffffffffffff001e6d067784ea05000a1d0103803c2278ea3e31ae5047ac270c50542108007140818081c0a9c0d1c081000101010108e80030f2705a80b0588a0058542100001e04740030f2705a80b0588a0058542100001a000000fd00383d1e873c000a202020202020000000fc004c472048445220344b0a2020200164020338714d9022201f1203040161605d5e5f230907076d030c001000b83c20006001020367d85dc401788003e30f0003e305c000e3060501023a801871382d40582c450058542100001e565e00a0a0a029503020350058542100001a000000ff003931304e544a4a42443731360a0000000000000000000000000000000000e3";
  dcc4kId = "00ffffffffffff001e6d0777a0380700071f0104b53c22789e3e31ae5047ac270c50542108007140818081c0a9c0d1c081000101010100d200a0f07050803020350058542100001aa36600a0f0701f803020350058542100001a000000fd00383d1e8738000a202020202020000000fc004c472048445220344b0a202020012602031c7144900403012309070783010000e305c000e606050152485d023a801871382d40582c450058542100001e565e00a0a0a029503020350058542100001a0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002c";

  notify = "${pkgs.libnotify}/bin/notify-send";
in
{
  programs.autorandr = {
    enable = true;

    hooks = {
      predetect = { };

      preswitch = { };

      postswitch = {
        "notify-xmonad" = ''
          ${notify} -i display "Display profile" "$AUTORANDR_CURRENT_PROFILE"
        '';

        "change-dpi" = ''
          case "$AUTORANDR_CURRENT_PROFILE" in
            away)
              DPI=130
              ;;
            dcc)
              DPI=120
              ;;
            home)
              DPI=120
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
          DP-1 = dcc4kId;
        };

        config = {
          DP-1 = {
            enable = true;
            crtc = 0;
            primary = true;
            position = "0x0";
            mode = "3840x2160";
            rate = "60.00";
          };
        };
      };

      "home" = {
        fingerprint = {
          DP-2-1 = t27pId;
          eDP-1 = laptopScreenId;
        };

        config = {
          DP-2-1 = {
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
          };
        };
      };
    };

  };
}

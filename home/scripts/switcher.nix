{ config, pkgs, ...}:

let
  zsh   = "${pkgs.zsh}/bin/zsh";
  rg     = "${pkgs.ripgrep}/bin/rg";
  xrandr = "${pkgs.xorg.xrandr}/bin/xrandr";
in
  pkgs.writeShellScriptBin "hms" ''
    monitors=$(${xrandr} --query | ${rg} '\bconnected')

    if [[ $monitors == *"HDMI-2"* ]]; then
      echo "Switching to HM config for HDMI display"
      home-manager -f /home/lem/dotfiles/home/display/hdmi.nix switch
    elif [[ $monitors == *"DP-2-2"* ]]; then
      echo "Switching to HM config for DP display"
      home-manager -f /home/lem/dotfiles/home/display/t27p-20.nix switch
    elif [[ $monitors == *"eDP"* ]]; then
      echo "Switching to HM config for eDP laptop display"
      echo $monitors
      home-manager -f /home/lem/dotfiles/home/display/edp.nix switch
    else
      echo "Could not detect monitor: $monitors"
      exit 1
    fi

    if [[ $1 == "restart" ]]; then
      echo "⚠️ Restarting X11 (requires authentication) ⚠️"
      systemctl restart display-manager
    fi
  ''

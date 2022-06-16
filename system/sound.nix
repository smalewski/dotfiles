{ config, pkgs, options, ... }:

{
  # Not sure if needed actually
  # boot.kernelPackages = pkgs.linuxPackagesFor pkgs.linux_latest;

  # High quality BT calls
  hardware.bluetooth.enable = true;
  #hardware.bluetooth.hsphfpd.enable = true;

  # Pipewire config
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    jack.enable = true;
    pulse.enable = true;

    # High quality BT calls
    #media-session.config.bluez-monitor.rules = [
      #{
        ## Matches all cards
        #matches = [{ "device.name" = "~bluez_card.*"; }];
        #actions = {
          #"update-props" = {
            #"bluez5.auto-connect" = [ "hfp_hf" "hsp_hs" "a2dp_sink" ];
          #};
        #};
      #}
      #{
        #matches = [
          ## Matches all sources
          #{ "node.name" = "~bluez_input.*"; }
          ## Matches all outputs
          #{ "node.name" = "~bluez_output.*"; }
        #];
        #actions = {
          #"node.pause-on-idle" = false;
        #};
      #}
    #];
  };
}

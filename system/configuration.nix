# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./wm/xmonad.nix
      ./cachix.nix
      ./sound.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Set your time zone.
  time.timeZone = "America/Santiago";

  networking = {
    hostName = "lembook-T460"; # Define your hostname.
    networkmanager.enable = true; # Enables wireless support via wpa_supplicant.

    # The global useDHCP flag is deprecated, therefore explicitly set to false here.
    # Per-interface useDHCP will be mandatory in the future, so this generated config
    # replicates the default behaviour.
    useDHCP = false;
    interfaces.enp0s31f6.useDHCP = true;
    interfaces.wlp4s0.useDHCP = true;


    # Firewall
    firewall.allowedTCPPorts =
      [
        51337 # transmission
        58429
        58430 # soulseek
      ];
  };

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "steam"
    "steam-original"
    "steam-runtime"
  ];

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.printing.drivers = [ pkgs.hplip ];

  # Enable sound.
  #sound.enable = true;
  #hardware.pulseaudio = {
  #enable = true;
  #extraConfig = "load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1"; # Needed by mpd
  #};

  fonts.fonts = [ (pkgs.nerdfonts.override { fonts = [ "Iosevka" ]; }) ];

  users.defaultUserShell = pkgs.zsh;
  users.mutableUsers = false;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users = {
    lem = {
      hashedPassword = "$6$IwtW7uYFu3io0RPy$Yik.cQuhPyemTgT/9SWCUaRtCFssE6uUXakHXrhE5pOqmoUz3Bm3sjcwDxzzz9KTnw0ftt4fp61l4qqZ/m6Ll.";
      isNormalUser = true;
      extraGroups = [
        "wheel" # Enable ‘sudo’ for the user.
        "networkmanager"
        "mpd"
      ];
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    alacritty
    autorandr
    cmake
    ispell
    fd
    fzf
    git
    gnupg
    nix-prefetch-github
    nixpkgs-fmt
    pass
    pinentry
    pinentry-curses
    ripgrep
    rofi
    thefuck
    vim
    wget
  ];

  environment.sessionVariables = {
    TERM = [ "alacritty" ];
  };

  services.mpd = {
    enable = true;
    user = "lem";
    extraConfig = ''
      audio_output {
        type "pipewire"
        name "PipeWire"
      }
    '';
  };

  systemd.services.mpd.environment = {
    XDG_RUNTIME_DIR = "/run/user/1000";
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  services.pcscd.enable = true;
  programs = {
    gnupg.agent = {
      enable = true;
      pinentryFlavor = "curses";
      enableSSHSupport = true;
    };
    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;
      ohMyZsh = {
        enable = true;
        plugins = [
          "common-aliases"
          "fzf"
          "git"
          "gitfast"
          "history"
          "sudo"
          "thefuck"
        ];
        theme = "half-life";
      };
    };
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };

  };

  nix = {
    package = pkgs.nixFlakes;
    settings = {
      trusted-users = [ "root" "lem" ];
    };
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs = true
      keep-derivations = true
    '';
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?

}


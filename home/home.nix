{ config, pkgs, ... }:

let
  defaultPkgs = with pkgs; [
    any-nix-shell
    arandr
    bottom
    cachix
    dconf2nix
    coq
    discord
    killall
    libnotify
    okular
    pavucontrol
    pasystray
    pulsemixer
    rnix-lsp
    spotify
    thunderbird
    vlc
    xclip
    zulip
  ];

  gitPkgs = with pkgs.gitAndTools; [
    diff-so-fancy # git diff with colors
    git-crypt     # git files encryption
    hub           # github command-line client
    tig           # diff and commit view
  ];

  polybarPkgs = with pkgs; [
    font-awesome-ttf      # awesome fonts
    material-design-icons # fonts with glyphs
  ];

  xmonadPkgs = with pkgs; [
   # networkmanager_dmenu   # networkmanager on dmenu
    networkmanagerapplet   # networkmanager applet
  # nitrogen               # wallpaper manager
    xcape                  # keymaps modifier
    xorg.xkbcomp           # keymaps modifier
    xorg.xmodmap           # keymaps modifier
    xorg.xrandr            # display manager (X Resize and Rotate protocol)
  ];

  scripts = pkgs.callPackage ./scripts/default.nix { inherit config pkgs; };

in

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  nixpkgs.config.allowUnfree = true;

  imports = (import ./programs) ++ (import ./services) ++ [(import ./themes)];

  home = {
    username = "lem";
    homeDirectory = "/home/lem";
    stateVersion = "21.11";

    packages = defaultPkgs ++ gitPkgs ++ polybarPkgs ++ xmonadPkgs ++ scripts;

    sessionVariables = {
      DISPLAY = ":0";
      EDITOR = "vim";
    };
  };

  systemd.user.startServices = "sd-switch";
  news.display = "silent";

  programs = {
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    gpg.enable = true;
    ssh.enable = true;
  };

}

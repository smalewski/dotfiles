{ config, pkgs, ... }:

let
  defaultPkgs = with pkgs; [
    any-nix-shell
    arandr
    bottom
    cachix
    cozy
    dconf2nix
    libnotify
    pandoc
    okular
    rclone
    sqlite
    xclip
    zathura

    # Communications
    discord
    thunderbird
    zulip

    # Games
    minecraft

    #Langs
    agda
    gcc
    rnix-lsp

    # Media
    ncmpcpp
    soulseekqt
    transmission-qt
    vlc

    # Music
    carla
    qsynth
    qsampler

    # Volume
    pasystray
    pulsemixer
    pavucontrol

    # Research
    zotero
  ];

  gitPkgs = with pkgs.gitAndTools; [
    diff-so-fancy # git diff with colors
    git-crypt # git files encryption
    hub # github command-line client
    tig # diff and commit view
  ];

  polybarPkgs = with pkgs; [
    font-awesome # awesome fonts
    material-design-icons # fonts with glyphs
  ];

  xmonadPkgs = with pkgs; [
    # networkmanager_dmenu   # networkmanager on dmenu
    networkmanagerapplet # networkmanager applet
    # nitrogen               # wallpaper manager
    xcape # keymaps modifier
    xorg.xkbcomp # keymaps modifier
    xorg.xmodmap # keymaps modifier
    xorg.xrandr # display manager (X Resize and Rotate protocol)
  ];

  scripts = pkgs.callPackage ./scripts/default.nix { inherit config pkgs; };

in

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  nixpkgs.config.allowUnfree = true;

  imports = (import ./programs) ++ (import ./services) ++ [ (import ./themes) ];

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

    emacs = {
      enable = true;
      extraPackages = epkgs: (with epkgs; [
        pdf-tools
        org-pdftools
        vterm
      ]);
    };

    gpg.enable = true;
    ssh.enable = true;
  };
}

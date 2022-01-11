{ pkgs, lib, ... }:

{
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      # Interface
      dracula-theme.theme-dracula
      vscodevim.vim
      vspacecode.vspacecode

      # Languages
      haskell.haskell
      jnoortheen.nix-ide

      # Utils
      kahole.magit
      vspacecode.whichkey
    ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "agda-mode";
        publisher = "banacorn";
        version = "0.3.7";
        sha256 = "0hmldbyldr4h53g5ifrk5n5504yzhbq5hjh087id6jbjkp41gs9b";
      }
      {
        name = "vscoq";
        publisher = "maximedenes";
        version = "0.3.6";
        sha256 = "1sailpizg7zvncggdma9dyxdnga8jya1a2vswwij1rzd9il04j3g";
      }
      {
        name = "prettify-symbols-mode";
        publisher = "siegebell";
        version = "0.4.2";
        sha256 = "0jpv9jy9hll3ypx4638j0sabjdlnhrw3lsd876x2p4cyjbvd8xn8";
      }
      {
        name = "nix-env-selector";
        publisher = "arrterian";
        version = "1.0.7";
        sha256 = "0mralimyzhyp4x9q98x3ck64ifbjqdp8cxcami7clvdvkmf8hxhf";
      }
    ];
  };
}

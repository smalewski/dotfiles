{ config, pkgs, ...}:

let
  git = "${pkgs.git}/bin/git";
in
  pkgs.writeShellScriptBin "doom-reload" ''
    DOOM="$HOME/.emacs.d"

    if [ ! -d "$DOOM" ]; then
        ${git} clone https://github.com/hlissner/doom-emacs.git $DOOM
        $DOOM/bin/doom -y install
    fi

    $DOOM/bin/doom sync
  ''

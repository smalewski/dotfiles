{ pkgs, ... }:

{
  programs.alacritty = {
    enable = true;
    settings = {
      bell = {
        animation = "EaseOutExpo";
        duration = 5;
        color = "#ffffff";
      };
      colors = {
        primary = {
          background = "#040404";
          foreground = "#c5c8c6";
        };
      };
      font = {
        size = 8;
      };
      selection.save_to_clipboard = true;
      shell.program = "${pkgs.zsh}/bin/zsh";
      window = {
        opacity = 0.8;
        decorations = "full";
        padding = {
          x = 5;
          y = 5;
        };
      };
    };
  };
}

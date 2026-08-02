{ pkgs, ... }:

{
  home.packages = with pkgs; [
    firefox
    htop
    tmux
  ];

  home.file.".xinitrc".text = "exec icewm";
}

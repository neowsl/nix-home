{ pkgs, ... }:

{
  home.packages = with pkgs; [
    htop
    tmux
  ];

  home.file.".xinitrc".text = "exec icewm";
}

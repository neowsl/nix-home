{ pkgs, ... }:

{
  home.packages = with pkgs; [
    cloudflared
    wslu
  ];

  programs.ssh.matchBlocks."minas-tirith.nealwang.dev" = {
    proxyCommand = "cloudflared access ssh --hostname %h";
  };
}

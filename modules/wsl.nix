{ pkgs, ... }:

{
  home.packages = with pkgs; [
    cloudflare-warp
    wslu
  ];

  programs.ssh = {
    enable = true;
    settings = {
      "minas-tirith" = {
        HostName = "192.168.1.12";
        User = "neo";
      };

      "attu" = {
        HostName = "attu.cs.washington.edu";
        User = "neo";

        ControlMaster = "auto";
        ControlPath = "~/.ssh/ans-%r@%h:%p";
        ControlPersist = "10m";
      };
    };
  };
}

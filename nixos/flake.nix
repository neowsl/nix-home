{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      lanzaboote,
      flake-utils,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
      in
      {
        packages.default = pkgs.hello;
      }
    )
    // {
      nixosConfigurations.fynn = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        modules = [
          ./hosts/fynn.nix
          ./hardware-configuration.nix
          lanzaboote.nixosModules.lanzaboote

          (
            { pkgs, lib, ... }:
            {
              environment.systemPackages = with pkgs; [
                sbctl
              ];

              boot.loader.systemd-boot.enable = lib.mkForce false;

              boot.lanzaboote = {
                enable = true;
                pkiBundle = "/var/lib/sbctl";
              };
            }
          )
        ];
      };
    };
}

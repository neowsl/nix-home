{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    hashword.url = "github:neowsl/hashword";
    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      nixpkgs-unstable,
      hashword,
      zen-browser,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
          permittedInsecurePackages = [
            "beekeeper-studio-5.1.5"
          ];
        };
      };
      pkgsUnstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
    in
    {
      homeConfigurations.neo = home-manager.lib.homeManagerConfiguration {
        pkgs = pkgs;

        modules = [ ./home.nix ];

        extraSpecialArgs = {
          pkgsUnstable = pkgsUnstable;
          hashword = hashword;
          zen-browser = zen-browser;
        };
      };
    };
}

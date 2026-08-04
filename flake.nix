{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # extra packages
    awww.url = "git+https://codeberg.org/LGFae/awww";
    catppuccin.url = "github:catppuccin/nix/release-26.05";
    dgop = {
      url = "github:AvengeMedia/dgop";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dms = {
      url = "github:AvengeMedia/DankMaterialShell/stable";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hashword.url = "git+https://git.nealwang.dev/neo/hashword";
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
      catppuccin,
      ...
    }@inputs:
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
      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };

      pkgsets = import ./lib/packages { inherit pkgs pkgs-unstable; };

      mkHome =
        hostModules:
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;

          extraSpecialArgs = { inherit inputs pkgs-unstable pkgsets; };

          modules = [
            ./home.nix
            catppuccin.homeModules.catppuccin
          ]
          ++ hostModules;
        };
    in
    {
      homeConfigurations = {
        rivendell = mkHome [
          ./hosts/rivendell.nix
          ./modules/desktop.nix
        ];
        minas-tirith = mkHome [
          ./hosts/minas-tirith.nix
          ./modules/server.nix
        ];
        osgiliath = mkHome [
          ./hosts/osgiliath.nix
          ./modules/wsl.nix
        ];
      };
    };
}

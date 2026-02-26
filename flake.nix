{
  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    haskell-flake.url = "github:srid/haskell-flake";
    nixpkgs.url = "github:nixos/nixpkgs/89c2b2330e733d6cdb5eae7b899326930c2c0648";
    systems.url = "github:nix-systems/default";
  };
  outputs = inputs @ {
    self,
    nixpkgs,
    flake-parts,
    ...
  }:
    flake-parts.lib.mkFlake { inputs = inputs // { inherit (inputs) nixpkgs nixpkgs-latest; }; } {
      systems = import inputs.systems;
      imports = [inputs.haskell-flake.flakeModule];

      perSystem = {
        self',
        pkgs,
        lib,
        config,
        ...
      }: {
        haskellProjects.default = {
            
          basePackages = pkgs.haskell.packages.ghc98;
          devShell = {
            tools = hp: {
              cabal-install = hp.cabal-install;
              ghcid = hp.ghcid;
            };
            hlsCheck.enable = false;
          };
          autoWire = ["packages" "checks" "apps"];
          packages = {
            Diff.source = "0.5";
            witherable.source = "0.5";
            base-compat-batteries.source="0.13.1";
            base-compat.source="0.13.1";
            attoparsec-aeson.source="2.1.0.0";
          };
          settings = {
            aeson.check = false;
            aeson.jailbreak = true;
            attoparsec-aeson.jailbreak = true;
            deriving-aeson.jailbreak = true;
          };

          
        };
        packages.default =  self'.packages.aeson;
      };
    };
}
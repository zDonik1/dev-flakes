{
  description = "A template for rust using crago2nix.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    cargo2nix = {
      url = "github:cargo2nix/cargo2nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";

        # Override the rust-overlay in cargo2nix to get newer rustc versions
        # rust-overlay = {
        #   url = "github:oxalica/rust-overlay";
        #   inputs = {
        #     nixpkgs.follows = "nixpkgs";
        #   };
        # };
      };
    };
  };

  outputs =
    {
      nixpkgs,
      flake-utils,
      cargo2nix,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ cargo2nix.overlays.default ];
        };

        rustPkgs = pkgs.rustBuilder.makePackageSet {
          rustVersion = "1.75.0";
          packageFun = import ./Cargo.nix;
          # Should be set to true in case packaging outside the project
          # ignoreLockHash = true;
        };
      in
      {
        packages = {
          # <package> = (rustPkgs.workspace.<package> { });
          # default = packages.<package>;
        };

        devShells = {
          default = rustPkgs.workspaceShell { packages = [ cargo2nix.packages."${system}".cargo2nix ]; };
        };
      }
    );
}

{
  description = "Contains my commanly used shells and templates.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    pytest = {
      url = "./pytest";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };
  };

  outputs =
    { nixpkgs, flake-utils, ... }:
    let
      defaultSystemOutputs = system: {
        devShells = rec {
          pytest =
            ((import ./pytest/flake.nix).outputs { inherit nixpkgs flake-utils; })
            .devShells."${system}".default;

          default = pytest;
        };
      };

      otherOutputs = {
        templates.pytest = {
          path = ./pytest;
          description = "A python project including pytest and debugpy for testing and daebugging with DAP";
        };
      };
    in
    flake-utils.lib.eachDefaultSystem defaultSystemOutputs // otherOutputs;
}

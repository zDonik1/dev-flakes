{
  description = "Contains my commanly used shells and templates.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    { nixpkgs, flake-utils, ... }:
    let
      defaultSystemOutputs = system: {
        devShells = rec {
          default = pytest;

          pytest =
            ((import ./pytest/flake.nix).outputs { inherit nixpkgs flake-utils; })
            .devShells."${system}".default;

          godot =
            ((import ./godot/flake.nix).outputs { inherit nixpkgs flake-utils; }).devShells."${system}".default;
        };
      };

      otherOutputs = {
        templates = {
          pytest = {
            path = ./pytest;
            description = "A python project including pytest and debugpy for testing and daebugging with DAP";
          };

          godot = {
            path = ./godot;
            description = "A template for Godot 4 based projects";
          };
        };
      };
    in
    flake-utils.lib.eachDefaultSystem defaultSystemOutputs // otherOutputs;
}

{
  description = "Advent of Code solutions in Lean 4";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    aoc-cli = {
      url = "github:ahacop/aoc-cli";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, aoc-cli, ... }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      forAllSystems =
        f:
        nixpkgs.lib.genAttrs systems (
          system:
          f (
            import nixpkgs {
              inherit system;
            }
          )
        );
    in
    {
      devShells = forAllSystems (pkgs: {
        default = pkgs.mkShell {
          packages = [
            pkgs.lean4
            pkgs.just
            aoc-cli.packages.${pkgs.stdenv.hostPlatform.system}.default
          ];
        };
      });

      formatter = forAllSystems (pkgs: pkgs.nixfmt);
    };
}

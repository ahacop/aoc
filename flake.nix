{
  description = "Advent of Code solutions in Lean 4";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    aoc-cli.url = "github:ahacop/aoc-cli";
    # lean-fmt has one release per Lean toolchain, tagged with the toolchain
    # version. The tag must match the lean4 version in nixpkgs.
    lean-fmt-src = {
      url = "github:jcreinhold/lean-fmt/v4.35.0";
      flake = false;
    };
  };

  outputs =
    {
      nixpkgs,
      aoc-cli,
      lean-fmt-src,
      ...
    }:
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

      # The Lean formatter. `lean-fmt lsp` is the language server that
      # Neovim uses to format a Lean file on save.
      mkLeanFmt =
        pkgs:
        pkgs.stdenv.mkDerivation {
          pname = "lean-fmt";
          version = "4.35.0";
          src = lean-fmt-src;

          nativeBuildInputs = [ pkgs.lean4 ];

          buildPhase = ''
            runHook preBuild
            export HOME=$TMPDIR
            lake build lean-fmt artifactExtractor
            runHook postBuild
          '';

          installPhase = ''
            runHook preInstall
            install -Dm755 -t $out/bin \
              .lake/build/bin/lean-fmt \
              .lake/build/bin/lean-fmt-artifact-extract
            runHook postInstall
          '';
        };
    in
    {
      packages = forAllSystems (pkgs: {
        lean-fmt = mkLeanFmt pkgs;
      });

      devShells = forAllSystems (pkgs: {
        default = pkgs.mkShell {
          packages = [
            pkgs.lean4
            pkgs.just
            (mkLeanFmt pkgs)
            aoc-cli.packages.${pkgs.stdenv.hostPlatform.system}.default
          ];
        };
      });

      formatter = forAllSystems (pkgs: pkgs.nixfmt);
    };
}

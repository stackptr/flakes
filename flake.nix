{
  inputs = {
    nixpkgs-23-05.url = "github:nixos/nixpkgs/nixos-23.05";
    freckle.url = "github:freckle/flakes?dir=main";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = inputs:
    inputs.flake-utils.lib.eachDefaultSystem (system:
      let
        nixpkgsArgs = { inherit system; config = { }; };
        nixpkgs-23-05 = import inputs.nixpkgs-23-05 nixpkgsArgs;
        freckle = inputs.freckle.packages.${system};
      in
      rec {
        packages = rec {
          nodejs = freckle.nodejs-16-20-0;
          typescript = nixpkgs-23-05.typescript;
        };
        devShells.js =
          nixpkgs-23-05.mkShell {
            name = "js";
            buildInputs =
              with packages;
              [
                nodejs
                typescript
              ];
          };
        devShells.default = devShells.js;
      }
    );
}

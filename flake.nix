{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = inputs:
    inputs.flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import inputs.nixpkgs {
          inherit system;
          config = {};
        };
      in rec {
        devShells.js = pkgs.mkShell {
          name = "js";
          buildInputs = with pkgs; [
            nodejs
            typescript
          ];
        };
        devShells.default = devShells.js;
        formatter = pkgs.alejandra;
      }
    );
}

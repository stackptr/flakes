{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
  };
  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} (top @ {
      config,
      withSystem,
      moduleWithSystem,
      ...
    }: {
      flake = {
        nixConfig = {
          experimental-features = ["nix-command" "flakes"];
          extra-substituters = [
            "https://stackptr.cachix.org"
          ];
          extra-trusted-public-keys = [
            "stackptr.cachix.org-1:5e2q7OxdRdAtvRmHTeogpgJKzQhbvFqNMmCMw71opZA="
          ];
        };
        templates.default = {
          path = ./templates/default;
          description = "Flake template with preferred formatter and libs";
        };
      };
      systems = ["x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin"];
      perSystem = {
        pkgs,
        self',
        ...
      }: {
        devShells.web = pkgs.mkShell {
          name = "web";
          buildInputs = with pkgs; [
            deno
            nodejs
            typescript
          ];
        };
        devShells.default = self'.devShells.web;
        formatter = pkgs.alejandra;
      };
    });
}

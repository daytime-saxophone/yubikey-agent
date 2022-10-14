{
  description = "A basic gomod2nix flake";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.gomod2nix.url = "github:nix-community/gomod2nix";

  outputs = { self, nixpkgs, flake-utils, gomod2nix }:
    (flake-utils.lib.eachSystem
      [
        "aarch64-linux"
        "aarch64-darwin"
        "i686-linux"
        "x86_64-darwin"
        "x86_64-linux"
      ]
      (system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ gomod2nix.overlays.default ];
          };

        in
        {
          #devShells.default = pkgs.mkShell {
          #  buildInputs = with pkgs; [ gomod2nix ];
          #};
          packages.default = pkgs.callPackage ./. { };
          devShells.default = import ./shell.nix { inherit pkgs self; };
        })
    );
}

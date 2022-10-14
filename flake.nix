{
  description = "A basic gomod2nix flake";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.gomod2nix.url = "github:nix-community/gomod2nix";

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    gomod2nix,
  }: (flake-utils.lib.eachSystem [
      "aarch64-linux"
      "aarch64-darwin"
      "i686-linux"
      "x86_64-darwin"
      "x86_64-linux"
    ]
    (system: let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [gomod2nix.overlays.default];
      };

      yubikey-agent = pkgs.callPackage ./. {};
      development = pkgs.mkShell {
        packages = [
          pkgs.gomod2nix
          (pkgs.mkGoEnv {pwd = ./.;})
          yubikey-agent
        ];
      };
    in {
      packages.default = yubikey-agent;
      defaultPackage = yubikey-agent;

      devShells.default = development;
      devShell = development;
    }));
}

let

beamSource = (import <nixpkgs> {}).fetchFromGitHub {
  owner = "tathougies";
  repo = "beam";
  rev = "db7e1d387b7ddbab13e22d65d1757b5257a8afe9";
  sha256 = "1wqnqryizi044212zn9m0nbyzmryx8l72vj9nd09q27rh5403df7";
};

pkgs = import (builtins.fetchTarball {
  url = "https://releases.nixos.org/nixpkgs/nixpkgs-19.09pre188239.c0e56afddbc/nixexprs.tar.xz";
  sha256 = "02sijmad7jybzwf063aig6bsaw4h85as0ax4x2425c867n62xnxz";
}) {};

haskellPackages = pkgs.haskell.packages.ghc865.extend (self: super: {
  beam-automigrate-example = self.callCabal2nix "beam-automigrate-example" ./. {};

  beam-core = self.callCabal2nix "beam-core" "${beamSource}/beam-core" {};
  beam-migrate = self.callCabal2nix "beam-migrate" "${beamSource}/beam-migrate" {};
  beam-postgres = self.callCabal2nix "beam-postgres" "${beamSource}/beam-postgres" {};
  beam-sqlite = self.callCabal2nix "beam-sqlite" "${beamSource}/beam-sqlite" {};
});


in haskellPackages.beam-automigrate-example

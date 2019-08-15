let

pkgs = import (builtins.fetchTarball {
  url = "https://releases.nixos.org/nixpkgs/nixpkgs-19.09pre188239.c0e56afddbc/nixexprs.tar.xz";
  sha256 = "02sijmad7jybzwf063aig6bsaw4h85as0ax4x2425c867n62xnxz";
}) {};

beamSource = pkgs.fetchFromGitHub {
  owner = "tathougies";
  repo = "beam";
  rev = "db7e1d387b7ddbab13e22d65d1757b5257a8afe9";
  sha256 = "1wqnqryizi044212zn9m0nbyzmryx8l72vj9nd09q27rh5403df7";
};

mkBeamPackage = self: name: self.callCabal2nix name "${beamSource}/${name}" {};

haskellPackages = pkgs.haskell.packages.ghc865.extend (self: super: let mk = mkBeamPackage self; in {
  beam-automigrate-example = self.callCabal2nix "beam-automigrate-example" ./. {};

  beam-core = mk "beam-core";
  beam-migrate = mk "beam-migrate";
  beam-migrate-cli = mk "beam-migrate-cli";
  beam-postgres = mk "beam-postgres";
  beam-sqlite = mk "beam-sqlite";
});

in haskellPackages.beam-automigrate-example // {
  inherit (haskellPackages) beam-migrate-cli;
}

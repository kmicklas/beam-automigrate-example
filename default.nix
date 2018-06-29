let

beamSource = (import <nixpkgs> {}).fetchFromGitHub {
  owner = "tathougies";
  repo = "beam";
  rev = "7b76eba8c05a7f64052073fd927947fd96ce5252";
  sha256 = "1nadxmzj9nz14vwb56gszjhk8zv5bljfz9lmjvaihwj148g9kc2p";
};

config = {
  packageOverrides = pkgs: {
    haskellPackages = pkgs.haskellPackages.override {
      overrides = self: super: {
        beam-automigrate-example = self.callCabal2nix "beam-automigrate-example" ./. {};

        beam-core = self.callCabal2nix "beam-core" "${beamSource}/beam-core" {};
        beam-migrate = self.callCabal2nix "beam-migrate" "${beamSource}/beam-migrate" {};
        beam-postgres = self.callCabal2nix "beam-postgres" "${beamSource}/beam-postgres" {};
        beam-sqlite = self.callCabal2nix "beam-sqlite" "${beamSource}/beam-sqlite" {};
      };
    };
  };
};

pkgs = (import ((import <nixpkgs> {}).fetchFromGitHub {
  owner = "NixOS";
  repo = "nixpkgs-channels";
  rev = "e686bd277196f33fccb685c4526333ebc50d1768";
  sha256 = "0vimzd0f917dzrw2dpfn2y64nlcjsdbqyffkxi118qyppyhm54jy";
})) { inherit config; };

in pkgs.haskellPackages.beam-automigrate-example

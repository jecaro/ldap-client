{ nixpkgs ? import <nixpkgs> {}, compiler ? "ghc8104" }: let
  inherit (nixpkgs) pkgs;
  haskell = pkgs.haskell.packages.${compiler};

  ghc = haskell.ghcWithPackages(ps: [
    ps.doctest ps.hspec-discover ps.hlint ps.haskell-language-server
  ]);
  npm = import ./npm {};

  this = import ./default.nix { inherit nixpkgs compiler; };
in
  pkgs.mkShell rec {
    inputsFrom = [ this.env ];
    buildInputs = [
      ghc
      haskell.cabal-install
      npm.nodePackages.ldapjs
    ];
    shellHook = ''
      ${this.env.shellHook}
      cabal configure --enable-tests --package-db=$NIX_GHC_LIBDIR/package.conf.d
    '';
  }

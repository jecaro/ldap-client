{ nixpkgs ? import <nixpkgs> {}, compiler ? "ghc8104" }: let
  ghc = nixpkgs.pkgs.haskell.packages.${compiler};
  npm = import ./npm {};
in
  ghc.callCabal2nix "ldap-client" ./. {
    mkDerivation = args: ghc.mkDerivation(args // {
      buildTools = (if args ? buildTools then args.buildTools else []) ++ [ npm.nodePackages.ldapjs ];
    });
  }

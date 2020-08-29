{ nixpkgs ? import <nixpkgs> {} }:

let

  inherit (nixpkgs) pkgs;

  mkSpacePkg =
    { mkDerivation, base, hmatrix, loop, mtl, OpenGL, SDL, stdenv }:
      mkDerivation {
        pname = "Spacecraft-Experiment";
        version = "0.1.0.0";
        src = pkgs.lib.cleanSource ./.;
        isLibrary = true;
        isExecutable = true;
        libraryHaskellDepends = [ base hmatrix loop OpenGL SDL ];
        executableHaskellDepends = [ base mtl SDL ];
        license = "unknown";
        hydraPlatforms = stdenv.lib.platforms.none;
      };

  h = pkgs.haskell;
  hp = pkgs.haskellPackages;
  dontProfile = pkg:
    h.lib.disableExecutableProfiling (h.lib.disableLibraryProfiling pkg);
  drv =
    h.lib.dontHaddock (dontProfile (hp.callPackage mkSpacePkg {}));

in

  if pkgs.lib.inNixShell then drv.env else drv

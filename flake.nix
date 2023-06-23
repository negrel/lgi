{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { flake-utils, nixpkgs, fenix, ... }@inputs:
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = import nixpkgs {
            inherit system;
          };
          lib = pkgs.lib;
          luaPkgs = pkgs.luajitPackages;
        in
        {
          pkgs = pkgs;
          debug = lib;
          packages = rec {
            default = lgi;
            lgi = pkgs.callPackage
              ({ pkgs, fetchFromGitHub, buildLuaPackage, lua }:
                buildLuaPackage {
                  pname = "lgi";
                  version = "0.9.2-1";
                  src = pkgs.fetchFromGitHub {
                    owner = "negrel";
                    repo = "lgi";
                    rev = "975737940d4463abc107fc366b9ab817e9217e0b";
                    sha256 = "sha256-G13BrqUmHwRtlmBVafo0LiwsX4nL/muw0/9cca+sigg=";
                  };

                  propagatedBuildInputs = [ lua ] ++ (with pkgs;
                    [
                      gobject-introspection
                      pkg-config
                    ]);

                  meta = {
                    homepage = "http://github.com/pavouk/lgi";
                    description = "Lua bindings to GObject libraries";
                    license.fullName = "MIT/X11";
                  };
                })
              {
                inherit (luaPkgs) buildLuaPackage lua;
                inherit pkgs;
              };
          };
        });
}

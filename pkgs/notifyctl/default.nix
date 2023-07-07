{ stdenv, pkgs, lib, makeWrapper, ... }:
stdenv.mkDerivation {    
    pname = "notifyctl";    
    version = "1.0";    
    src = ./src; 
    dontBuild = true; 
    nativeBuildInputs = [ makeWrapper ];
    buildInputs = [ pkgs.libnotify ]; 

    installPhase = ''   
      mkdir -p $out/bin
      install -t $out/bin ./notifyctl
      wrapProgram $out/bin/notifyctl --prefix PATH : ${lib.makeBinPath [ pkgs.libnotify ]}
    '';   
}

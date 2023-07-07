{ stdenv, pkgs, ... }:

stdenv.mkDerivation {    
    pname = "audioctl";    
    version = "1.0";    
    src = ./src; 
    dontBuild = true; 

    installPhase = ''   
    mkdir -p $out/bin
    install -t $out/bin ./audioctl
    '';   
}

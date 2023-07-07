{ stdenv, pkgs, lib, makeWrapper, ... }:

stdenv.mkDerivation {    
    pname = "backup";    
    version = "1.0";    
    src = ./src; 
    dontBuild = true; 
    nativeBuildInputs = [ makeWrapper ];
    buildInputs = [ pkgs.libnotify ]; 

    installPhase = ''
      mkdir -p $out/bin
      install -t $out/bin ./backup
      wrapProgram $out/bin/backup --prefix PATH : ${lib.makeBinPath [ pkgs.libnotify pkgs.gnutar pkgs.coreutils-full pkgs.gnugrep pkgs.gzip ]}
    '';   
}

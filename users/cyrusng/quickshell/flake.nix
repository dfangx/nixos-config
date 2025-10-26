{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/default";
    mainCfg.url = "../../../";
  };
  outputs = { systems, nixpkgs, self, ... }@inputs:
  let
    eachSystem = nixpkgs.lib.genAttrs (import systems);
  in
  {
    devShells = eachSystem(system:
    let
      pkgs = import nixpkgs { inherit system; };
      nvim = inputs.mainCfg.packages.${system}.default.extend {
        plugins.lsp.servers.qmlls = {
          enable = true;
          cmd = [
            "${pkgs.kdePackages.qtdeclarative}/bin/qmlls"
            "-E"
          ];
        };
      };
    in
    {
      default = pkgs.mkShell {
        nativeBuildInputs = [
          nvim
        ];
      };
      interactiveShellInit = ''
        curDate="[\d]"
        machInfo="quickshell-dev"
        dir="\w"
        nix d
        prompt="\$"
        PS1="\[\e[1;34m\]$curDate \[\e[1;34m\]$machInfo\[\e[1;32m\] $dir\n\[\e[1;32m\]$prompt\[\e[0m\] "
      '';
    });
  };
}

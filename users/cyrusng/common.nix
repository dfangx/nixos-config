{ config, pkgs, lib, inputs, host, ... }:
let
  terminal = "${lib.getExe pkgs.alacritty}";
in
{
  imports = [
    inputs.nur.modules.homeManager.default

    # Programs
    ../../homeManagerModules
  ];

  bash.enable = true;
  beets.enable = true;
  dircolors.enable = true;
  fonts.enable = true;
  fzf.enable = true;
  git.enable = true;
  nixvim.enable = true;
  tmux.enable = true;
  xdgCfg.enable = true;

  home = rec {
    username = "cyrusng";
    homeDirectory = "/home/${username}";
    sessionVariables = {
      EDITOR = "nvim";
      PROMPT_DIRTRIM = 3;
    };
    shellAliases = {
      po = "poweroff";
      rb = "reboot";
      ls = "ls --color=auto";
      la = "ls -a";
      lh = "ls -h";
      ll = "ls -lh";
      lal = "ls -lha";
      rm = "rm -I";
      rr = "rm -Ir";
      mv = "mv -v";
      rmdir = "rmdir -v";
      mkdir = "mkdir -pv";
      df = "df -h";
      diff = "diff --color=auto";
      grep = "grep --color=auto";
      ZZ = "exit";
      e = "$EDITOR";
      g = "git";
      gst = "git status";
      gcm = "git commit";
      gps = "git push";
      gpl = "git pull";
      gmg = "git merge";
      gco = "git checkout";
      ga = "git add";
      gdf = "git diff";
      gbr = "git branch";
      gap = "git apply";
      gl = "git log";
      gcl = "git clone";
      grb = "git rebase";
      gsmu = "git submodule foreach git pull";
      rpi = "ssh ${config.home.username}@slothpi.duckdns.org";
    };
    stateVersion = "22.11";
    packages = with pkgs; [
      fd
      bat
      xdg-user-dirs
      unzip
      keepassxc
      hledger
    ];
  };

  nix = {
    package = pkgs.nix;
    checkConfig = true;
    extraOptions = ''
      experimental-features = nix-command flakes
      min-free = ${toString (1024 * 1024 * 1024)}
    '';
    settings = {
      trusted-users = [ "cyrusng" ];
      substituters = [
        "https://cache.nixos.org/"
        "https://nix-community.cachix.org"
        # "https://nixpkgs-wayland.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        # "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
      ];
      auto-optimise-store = true;
    };
  };
  
  nixpkgs.config.allowUnfreePredicate = (pkg: true);

  programs.home-manager.enable = true;
}

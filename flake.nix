{
  description = "NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgsStable.url = "github:nixos/nixpkgs/nixos-23.05";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nbfc-linux.url = "github:nbfc-linux/nbfc-linux";
    agenix.url = "github:ryantm/agenix";

    firefly = {
      url = "github:timhae/firefly";
      inputs.nixpkgs.follows = "nixos";
    };
    nixos.url = "github:NixOS/nixpkgs/nixos-22.11";

    neovim-nix.url = "github:dfangx/nvim-flake";
    nixneovim = {
      url = "github:nixneovim/nixneovim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixneovimplugins.url = "github:jooooscha/nixpkgs-vim-extra-plugins";
    # nixvim = {
    #   url = "github:nix-community/nixvim";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nur.url = "github:nix-community/NUR";

    hyprland-contrib = {
       url = "github:hyprwm/contrib";
       inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
       url = "github:hyprwm/Hyprland";
       inputs.nixpkgs.follows = "nixpkgs";
    };

    hypridle = {
       url = "github:hyprwm/hypridle";
       inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprlock = {
       url = "github:hyprwm/hyprlock";
       inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland-nix.url = "github:spikespaz/hyprland-nix";

    hyprgrass = {
       url = "github:horriblename/hyprgrass";
       inputs.hyprland.follows = "hyprland";
    };

    nixpkgs-wayland = {
      url = "github:nix-community/nixpkgs-wayland";
      follows = "nixpkgs";
    };
    # hyprland-nix.inputs.hyprland.follows = "hyprland-git";
  };

  outputs = { nixpkgs, nixpkgsStable, home-manager, ... }@inputs:
  rec {
    nixosConfigurations = {
      cykrotop = let
        system = "x86_64-linux";
        pkgs = nixpkgs.legacyPackages.${system};
      in
      nixpkgs.lib.nixosSystem {
        # inherit system;
        modules = [
          {
            nixpkgs.overlays = [
              (final: prev: { 
                steam = prev.steam.override { 
                  extraPkgs = pkgs: with pkgs; [ 
                    # stdenv.cc.cc.lib
                  ]; 
                }; 
                nbfc-linux = inputs.nbfc-linux.packages.${system}.nbfc;
                agenix = inputs.agenix.packages.${system}.default;
              })
            ];
          }
          inputs.agenix.nixosModules.default
          inputs.hyprland.nixosModules.default
          ./machines/cykrotop/configuration.nix
        ];
      };
      arcturus = let
        system = "x86_64-linux";
        pkgs = nixpkgs.legacyPackages.${system};
      in
      nixpkgs.lib.nixosSystem {
        # inherit system;
        specialArgs = { inherit inputs; };
        modules = [
          {
            nixpkgs.overlays = [
              (final: prev: { 
                steam = prev.steam.override { 
                  extraPkgs = pkgs: with pkgs; [ 
                  ]; 
                }; 
                nbfc-linux = inputs.nbfc-linux.packages.${system}.nbfc;
                agenix = inputs.agenix.packages.${system}.default;
              })
            ];
          }
          inputs.agenix.nixosModules.default
          inputs.hyprland.nixosModules.default
          inputs.nixos-hardware.nixosModules.lenovo-thinkpad-x1-yoga
          ./machines/arcturus/configuration.nix
        ];
      };
      slothpi = let
        system = "aarch64-linux";
        pkgs = nixpkgs.legacyPackages.${system};
      in
      nixpkgs.lib.nixosSystem {
        # inherit system;
        modules = [
          "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
          {
            nixpkgs.config.allowUnsupportedSystem = true;
            nixpkgs.overlays = [
              inputs.neovim-nix.overlays.${system}.default
              (final: super: {
                makeModulesClosure = x:
                super.makeModulesClosure (x // { allowMissing = true; });
                agenix = inputs.agenix.packages.${system}.default;
                hydroxideNew = final.hydroxide.overrideAttrs(old: {
                  version = "0.2.27";
                });
              })
              inputs.firefly.overlays.default
            ];
          }
          inputs.agenix.nixosModules.default
          inputs.firefly.nixosModules.firefly-iii
          ./machines/slothpi/configuration.nix
        ];
      };
    };
    images.slothpi = nixosConfigurations.slothpi.config.system.build.sdImage;
    homeConfigurations.cyrusng = let
      system = "x86_64-linux";
      # lib = nixpkgs.lib.extend (inputs.spikespaz-lib.lib.overlay);
      pkgs = nixpkgs.legacyPackages.${system};
      myOverlay = (final: prev: {
        freetube = prev.freetube.overrideAttrs (oldAttrs: {
          nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [ prev.makeWrapper ];

          postFixup = oldAttrs.postFixup + ''
          wrapProgram $out/bin/freetube \
          --add-flags --enable-features=UseOzonePlatform \
          --add-flags --ozone-platform=wayland
          '';
        });
        pkgsStable = nixpkgsStable.legacyPackages.${prev.system};
        rsgain = pkgs.callPackage pkgs/rsgain.nix { };
      });
    in 
    home-manager.lib.homeManagerConfiguration {
      inherit pkgs;

      extraSpecialArgs = { inherit inputs; };

      modules = [
        {
          nixpkgs.overlays = [
            (_: prev: { adwaita-icon-theme-without-gnome = prev.gnome.adwaita-icon-theme.overrideAttrs (oldAttrs: { passthru = null; }); })
            (_: prev: { adwaita-icon-theme-without-gnome = prev.gnome.adwaita-icon-theme.override      { gnome = null; gtk3 = null; }; })
            myOverlay
            inputs.neovim-nix.overlays.${system}.default
            # inputs.nixpkgs-wayland.overlays.${system}.default
          ];
        }
        inputs.nur.nixosModules.nur
        ./users/cyrusng/home.nix 
      ];
    };
  };
}

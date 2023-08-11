{
  description = "NixOS Configuration";

  inputs = {
    nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgsStable.url = "github:nixos/nixpkgs/nixos-23.05";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim-nix.url = "github:dfangx/nvim-flake";
    nbfc-linux.url = "github:nbfc-linux/nbfc-linux";
    hyprland-package.url = "github:hyprwm/Hyprland";
    hyprland-contrib.url = "github:hyprwm/contrib";
    hyprland = {
      url = "github:spikespaz/hyprland-flake";
      inputs.hyprland.follows = "hyprland-package";
    };
    spikespaz.url = "github:spikespaz/dotfiles";
    agenix.url = "github:ryantm/agenix";
    firefly = {
      url = "github:timhae/firefly";
      inputs.nixpkgs.follows = "nixos";
    };
    nixos.url = "github:NixOS/nixpkgs/nixos-22.11";
    nixneovim.url = "github:nixneovim/nixneovim";
  };

  outputs = { nixpkgs, nixpkgsStable, home-manager, ... }@inputs:
  let
    riverOverlay = (final: prev: {
      river = prev.river.overrideAttrs (oldAttrs: {
        nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [ prev.makeWrapper ];

        postInstall = ''
        wrapProgram $out/bin/river \
        --set XDG_SESSION_TYPE wayland \
        --set XDG_SESSION_DESKTOP river \
        --set XDG_CURRENT_DESKTOP river \
        --set MOZ_ENABLE_WAYLAND 1 \
        --set QT_QPA_PLATFORM wayland \
        --set SDL_VIDEODRIVER wayland \
        --set _JAVA_AWT_WM_NONREPARENTING 1
        '';
      });
    });
  in 
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
                    ]; 
                  }; 
                  nbfc-linux = inputs.nbfc-linux.packages.${system}.nbfc;
                  agenix = inputs.agenix.packages.${system}.default;
                })
                riverOverlay
              ];
            }
            inputs.agenix.nixosModules.default
            inputs.hyprland-package.nixosModules.default
            ./machines/cykrotop/configuration.nix
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
        lib = nixpkgs.lib.extend (import "${inputs.spikespaz}/lib");
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
        });
      in 
      home-manager.lib.homeManagerConfiguration {
        inherit lib pkgs;

        extraSpecialArgs = { inherit inputs; };

        modules = [
          {
            nixpkgs.overlays = [
              (_: prev: { adwaita-icon-theme-without-gnome = prev.gnome.adwaita-icon-theme.overrideAttrs (oldAttrs: { passthru = null; }); })
              (_: prev: { adwaita-icon-theme-without-gnome = prev.gnome.adwaita-icon-theme.override      { gnome = null; gtk3 = null; }; })
              riverOverlay
              myOverlay
              inputs.neovim-nix.overlays.${system}.default
              inputs.hyprland-package.overlays.default
              inputs.hyprland-contrib.overlays.default
              #inputs.nixneovim.overlays.default
            ];
          }
          # inputs.hyprland.homeManagerModules.default
          inputs.hyprland.homeManagerModules.default
          #inputs.nixneovim.nixosModules.default
          ./users/cyrusng/home.nix 
        ];
      };
    };
  }

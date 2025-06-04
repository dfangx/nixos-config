{
  description = "NixOS Configuration";

  inputs = {
    nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgsStable.url = "github:nixos/nixpkgs/nixos-24.11";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-gaming.url = "github:fufexan/nix-gaming";
    neovim-nix.url = "github:dfangx/nvim-flake";
    nbfc-linux.url = "github:nbfc-linux/nbfc-linux";
    agenix.url = "github:ryantm/agenix";
    firefly = {
      url = "github:timhae/firefly";
      inputs.nixpkgs.follows = "nixos";
    };
    nixos.url = "github:NixOS/nixpkgs/nixos-22.11";
    nixneovimplugins.url = "github:jooooscha/nixpkgs-vim-extra-plugins";
    nixneovim = {
      url = "github:nixneovim/nixneovim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      # inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nur.url = "github:nix-community/NUR";

    hyprland = {
      url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprgrass = {
      url = "github:horriblename/hyprgrass";
      inputs.hyprland.follows = "hyprland";
    };
    hypridle = {
      url = "github:hyprwm/hypridle";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprlock = {
      url = "github:hyprwm/hyprlock";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprpaper = {
      url = "github:hyprwm/hyprpaper";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland-virtual-desktops = {
      url = "github:levnikmyskin/hyprland-virtual-desktops";
      inputs.hyprland.follows = "hyprland";
    };
    hyprspace = {
      url = "github:KZDKM/Hyprspace";
      inputs.hyprland.follows = "hyprland";
    };
    split-monitor-workspaces = {
      url = "github:Duckonaut/split-monitor-workspaces";
      inputs.hyprland.follows = "hyprland";
    };

    ags.url = "github:Aylur/ags";
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
                  ]; 
                }; 
                nbfc-linux = inputs.nbfc-linux.packages.${system}.nbfc;
                agenix = inputs.agenix.packages.${system}.default;
              })
            ];
          }
          inputs.agenix.nixosModules.default
          inputs.hyprland.nixosModules.default
          ./hosts/cykrotop/configuration.nix
        ];
      };
      arcturus = let
        host = "arcturus";
      in
      nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs host; };
        modules = [
          ./hosts/${host}
        ];
      };
      regulus = let
        host = "regulus";
      in
      nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs host; };
        modules = [
          ./hosts/${host}
        ];
      };
      slothpi = let
        host = "slothpi";
      in
      nixpkgs.lib.nixosSystem {
        # inherit system;
        specialArgs = { inherit inputs host; };
        modules = [
          "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
          {
            nixpkgs.overlays = [
              (final: super: {
                makeModulesClosure = x:
                super.makeModulesClosure (x // { allowMissing = true; });
              })
            ];
          }
          ./hosts/${host}
        ];
      };
    };
    images.slothpi = nixosConfigurations.slothpi.config.system.build.sdImage;
    homeConfigurations = {
      "cyrusng@arcturus" = let
        host = "arcturus";
        system = "x86_64-linux";
        pkgs = nixpkgs.legacyPackages.${system};
        pkgsStable = nixpkgsStable.legacyPackages.${system};
      in 
      home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        extraSpecialArgs = { inherit inputs host pkgsStable; };

        modules = [
          {
            nixpkgs.overlays = [
              (_: prev: { adwaita-icon-theme-without-gnome = prev.adwaita-icon-theme.overrideAttrs (oldAttrs: { passthru = null; }); })
              (_: prev: { adwaita-icon-theme-without-gnome = prev.adwaita-icon-theme.override      { gnome = null; gtk3 = null; }; })
            ];
          }
          ./users/cyrusng/${host}.nix
        ];
      };
      "cyrusng@regulus" = let
        host = "regulus";
        system = "x86_64-linux";
        pkgs = nixpkgs.legacyPackages.${system};
      in
      home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        extraSpecialArgs = { inherit inputs host; };

        modules = [
          {
            nixpkgs.overlays = [
              (_: prev: { adwaita-icon-theme-without-gnome = prev.adwaita-icon-theme.overrideAttrs (oldAttrs: { passthru = null; }); })
              (_: prev: { adwaita-icon-theme-without-gnome = prev.adwaita-icon-theme.override      { gnome = null; gtk3 = null; }; })
            ];
          }
          ./users/cyrusng/${host}.nix
        ];
      };
      "cyrusng@slothpi" = let
        host = "slothpi";
        system = "aarch64-linux";
        pkgs = nixpkgs.legacyPackages.${system};
      in
      home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        extraSpecialArgs = { inherit inputs host; };

        modules = [
          ./users/cyrusng/home.nix
        ];
      };
    };

    packages."x86_64-linux" = let
      config = {
        imports = [ 
          ./homeManagerModules/programs/nixvim-config.nix
        ];
      };
      nixvim' = inputs.nixvim.legacyPackages."x86_64-linux";
      nvim = nixvim'.makeNixvim config;
    in
    {
      inherit nvim;
      default = nvim;
    };
  };
}

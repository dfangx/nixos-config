{ config, pkgs, lib, inputs, ... }:
{
  wayland.windowManager.hyprland = {
    settings = {
      monitor = [
        "DP-3,preferred,0x0,1"
        "DP-2,preferred,auto,1"
      ];

      workspace = 
      (
        # workspaces
        builtins.concatLists (builtins.genList (
          x: let
            ws = let
              c = (x + 1) / 10;
            in
            x + 1 - (c * 10);
          in [
            (
            if (ws == 1)
            then "${builtins.toString ws}, monitor:DP-1, default:true"
            else 
              if (ws == 2)
              then "${builtins.toString ws}, monitor:DP-2, default:true"
              else 
                if (ws / 2 * 2 == ws)
                then "${builtins.toString ws}, monitor:DP-2"
                else "${builtins.toString ws}, monitor:DP-1"
            )
          ]
        )
        10)
      );
    };
  };
}

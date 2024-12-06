{ config, pkgs, lib, inputs, ... }:
{
  wayland.windowManager.hyprland = {
    settings = {
      monitor = [
        "DP-1,preferred,0x0,1"
        "DP-3,preferred,auto-right,1"
        "desc:Technical Concepts Ltd Beyond TV 0x00010000,highres,auto-right,2.6666667"
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
              then "${builtins.toString ws}, monitor:DP-3, default:true"
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

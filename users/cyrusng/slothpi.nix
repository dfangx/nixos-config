{ lib, inputs, ... }:
let
in
{
    imports = [
        inputs.nur.modules.homeManager.default

        # Programs
        ./common.nix
    ];

    beets.enable = lib.mkForce false;
}

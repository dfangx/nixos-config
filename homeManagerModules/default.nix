{ config, lib, ... }:
{
  imports = [
    ./programs
    ./services
    ./desktop.nix
  ];
}

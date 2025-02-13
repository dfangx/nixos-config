{ config, lib, ... }:
{
  options.users.enable = lib.mkEnableOption "Enable common users";
  config = lib.mkIf config.users.enable {
    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.cyrusng = {
      isNormalUser = true;
      extraGroups = [ "wheel" ]; 
      hashedPassword = "$y$j9T$XgXobCeRJMzoHs79Qh/wN1$d/PKmABq92qsGEkNUv7oC9.zgr.SxvgmIkIgkS7nXE7";
    };
  };
}

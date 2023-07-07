{ config, pkgs, ... }:
{
  config.home.packages = with pkgs; [
    fuzzel
  ];

  config.xdg.configFile."fuzzel/fuzzel.ini".text = ''
    terminal=${config.home.sessionVariables.TERM} -e
    font=Source Code Pro for Powerline:size=12
    icons-enabled = false
    lines=30
    width=60
    dpi-aware=no
  
    [border]
    radius=0
    width=2
  
    [dmenu]
    exit-immediately-if-empty=yes
  
    [colors]
    background=3b4252ff
    text=e5e9f0ff
    selection=4c566aff
    selection-text=e5e9f0ff
    border=88c0d0ff
  
    [key-bindings]
    prev-with-wrap=Control+k
    next-with-wrap=Control+j
    delete-line=Control+Shift+d
  '';
}

{ ... }:
{
  programs.bash = {
    enable = true;
    initExtra = ''
      curDate="[\d]"
      machInfo="\u@\h"
      dir="\w"
      prompt="\$"
      PS1="\[\e[1;34m\]$curDate \[\e[1;34m\]$machInfo\[\e[1;32m\] $dir\n\[\e[1;32m\]$prompt\[\e[0m\] "
      unset curDate
      unset machInfo
      unset dir
      unset prompt

      stty -ixon
      set -o vi
      shopt -s autocd
    '';
  };
}

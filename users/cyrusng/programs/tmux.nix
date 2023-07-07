{ config, pkgs, ... }:
{
  programs.tmux = {
    enable = true;
    clock24 = true;
    keyMode = "vi";
    newSession = true;
    prefix = "C-Space";
    plugins = with pkgs; [
      tmuxPlugins.nord
    ];
    extraConfig = ''
      unbind C-a
      bind C-Space send-prefix

      unbind C-h
      unbind C-j
      unbind C-k
      unbind C-l
      bind -r C-h resize-pane -L
      bind -r C-j resize-pane -D
      bind -r C-k resize-pane -U
      bind -r C-l resize-pane -R

      unbind \;
      unbind Left
      unbind Down
      unbind Up
      unbind Right
      unbind h
      unbind j
      unbind k
      unbind l
      unbind v
      unbind b

      unbind -T copy-mode-vi 'Space'
      unbind -T copy-mode-vi 'Enter'
      bind-key -T copy-mode-vi 'v' send-keys -X begin-selection
      bind-key -T copy-mode-vi 'y' send-keys -X copy-selection-and-cancel
      bind-key -T copy-mode-vi 'r' send-keys -X rectangle-toggle
      bind-key -T copy-mode-vi 'V' send-keys -X select-line
      unbind ]
      bind p paste-buffer
      unbind [
      bind Escape copy-mode
      bind-key -T copy-mode-vi Escape send-keys -X cancel

      unbind n
      bind-key [ previous-window
      bind-key ] next-window

      unbind -n C-v
      unbind -n C-b
      unbind -n s
      unbind -n v
      bind v split-window -h -c "#{pane_current_path}"
      bind s split-window -v -c "#{pane_current_path}"
      unbind %
      unbind '"'

      is_vim="ps -o state= -o comm= -t '#{pane_tty}' | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?$'"
      bind-key -n C-h if-shell "$is_vim" "send-keys C-h"  "select-pane -L"
      bind-key -n C-j if-shell "$is_vim" "send-keys C-j"  "select-pane -D"
      bind-key -n C-k if-shell "$is_vim" "send-keys C-k"  "select-pane -U"
      bind-key -n C-l if-shell "$is_vim" "send-keys C-l"  "select-pane -R"
      bind-key -n C-\\ if-shell "$is_vim" "send-keys C-\\" "select-pane -l"
      bind-key -T copy-mode-vi C-h select-pane -L
      bind-key -T copy-mode-vi C-j select-pane -D
      bind-key -T copy-mode-vi C-k select-pane -U
      bind-key -T copy-mode-vi C-l select-pane -R
      bind-key -T copy-mode-vi C-\\ select-pane -l

      bind r source ${config.xdg.configHome}/tmux/tmux.conf
    '';
  };
}

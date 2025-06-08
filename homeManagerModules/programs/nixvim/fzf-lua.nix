{
  plugins.fzf-lua = {
    enable = true;
    settings = {
      winopts.split = "botright new";
    };
    keymaps = {
      "<leader>ff" = {
          action = "files";
      };
      "<leader>fs" = {
        action = "files";
        settings = {
          actions.default.__raw = "require'fzf-lua.actions'.file_split";
        };
      };
      "<leader>fv" = {
        action = "files";
        settings = {
          actions.default.__raw = "require'fzf-lua.actions'.file_vsplit";
        };
      };
      "<leader>ft" = {
        action = "files";
        settings = {
          actions.default.__raw = "require'fzf-lua.actions'.file_tabedit";
        };
      };
      "<leader>bb" = {
        action = "buffers";
      };
    };
  };
}

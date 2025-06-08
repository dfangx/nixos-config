{
  plugins = {
    treesitter = {
      enable = true;
      folding = true;
      settings = {
        ensure_installed = "all";
        indent.enable = true;
      };
    };
    treesitter-refactor.enable = true;
  };
}

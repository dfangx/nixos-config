{
  imports = [
    ./colorscheme.nix
    ./globals.nix
    ./options.nix
    ./keymaps.nix
    ./cmp.nix
    ./lsp.nix
    ./neorg.nix
    ./fzf-lua.nix
    ./treesitter.nix
    ./markdown.nix
  ];

  viAlias = true;
  vimAlias = true;

  autoCmd = [
    {
      event = "VimResized";
      pattern = "*";
      command = "wincmd =";
      group = "vimStart";
    }
    # {
    #   event = [
    #     "BufEnter"
    #   ];
    #   pattern = [
    #     "*.md"
    #     "*.norg"
    #   ];
    #   command = "ZenMode";
    #   group = "zen-mode";
    # }
    # {
    #   event = "FileType";
    #   pattern = [
    #     "markdown"
    #     "mkd"
    #     "text"
    #     "norg"
    #   ];
    #   command = "call pencil#init()";
    #   group = "pencil";
    # }
  ];
  autoGroups = {
    vimStart.clear = true;
    # pencil.clear = true;
    # zen-mode.clear = true;
  };

  plugins = {
    zen-mode = {
      enable = true;
    };
    lualine = {
      enable = true;
    };
    luasnip = {
      enable = true;
    };
    nvim-autopairs = {
      enable = true;
    };
    mkdnflow = {
      enable = true;
      wrap = true;
      links.conceal = true;
    };
  };

  filetype.pattern = { 
    ".*/hypr/.*%.conf" = "hyprlang";
  };
}

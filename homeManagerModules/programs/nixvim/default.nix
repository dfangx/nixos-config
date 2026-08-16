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
      settings.wrap = true;
      settings.links.conceal = true;
    };
    ledger = {
      enable = true;
      settings = {
        align_at = 72;
        default_commodity = "CAD";
        max_width = 80;
        fillstring = "     ";
        date_format = "%Y-%m-%d";
      };
    };
  };

  filetype.pattern = { 
    ".*/hypr/.*%.conf" = "hyprlang";
  };
}

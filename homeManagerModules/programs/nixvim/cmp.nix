{
  plugins = {
    cmp = {
      enable = true;
      autoEnableSources = true;
      cmdline = {
        "/" = {
          mapping = { __raw = "cmp.mapping.preset.cmdline()"; };
          sources = [
            {
              name = "buffer";
            }
          ];
        };
        ":" = {
          mapping = { __raw = "cmp.mapping.preset.cmdline()"; };
          sources = [
            {
              name = "cmdline";
            }
            {
              name = "cmp-cmdline-history";
            }
          ];
        };
      };
      settings = {
        mapping = {
          "<TAB>" = "cmp.mapping.select_next_item()";
          "<S-TAB>" = "cmp.mapping.select_prev_item()";
          "<C-e>" = "cmp.mapping.abort()";
          "<CR>" = "cmp.mapping.confirm({ select = true })";
        };
        completion = {
          completeopt = "menuone,noinsert,noselect";
        };
        snippet.expand = ''
          function(args)
            require('luasnip').lsp_expand(args.body)
          end
        '';
        sources = [
          {
            name = "nvim_lsp";
          }
          {
            name = "nvim_lsp_document_symbol";
          }
          {
            name = "nvim_lsp_signature_help";
          }
          {
            name = "buffer";
          }
          {
            name = "calc";
          }
          {
            name = "luasnip";
          }
          {
            name = "nvim_lua";
          }
          {
            name = "omni";
          }
          {
            name = "path";
          }
          {
            name = "treesitter";
          }
        ];
      };
    };
  };
}

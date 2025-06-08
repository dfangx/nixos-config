{
  plugins.lsp = {
    enable = true;
    servers = {
      nil_ls.enable = true;
    };
    keymaps = {
      silent = true;
      diagnostic = {
        "<leader>E" = "open_float";
        "[d" = "goto_prev";
        "]d" = "goto_next";
      };
      lspBuf = {
        "gd" = "definition";
        "gD" = "declaration";
        "gc" = "incoming_calls";
        "K" = "hover";
        "gi" = "implementation";
        "gr" = "references";
        "ga" = "code_action";
        "<C-s>" = "signature_help";
        "<leader>wa" = "add_workspace_folder";
        "<leader>wr" = "remove_workspace_folder";
        "<leader>D" = "type_definition";
        "<leader>rn" = "rename";
      };
    };
    onAttach = /*lua*/''
      vim.o.omnifunc = 'v:lua.vim.lsp.omnifunc'
  
      -- Set autocommands conditional on server_capabilities
      if client.server_capabilities.document_highlight then
        vim.api.nvim_exec([[
          hi LspReferenceRead cterm=bold ctermbg=red guibg=LightYellow
          hi LspReferenceText cterm=bold ctermbg=red guibg=LightYellow
          hi LspReferenceWrite cterm=bold ctermbg=red guibg=LightYellow
          augroup lsp_document_highlight
          autocmd!
          autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
          autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
          augroup END
        ]], 
        false)
      end
  
      local opts = { noremap = true, silent = true }
      vim.api.nvim_buf_set_keymap(0, 'n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
    '';
    capabilities = /*lua*/''
      capabilities.textDocument.completion.completionItem.snippetSupport = true
      capabilities.textDocument.completion.completionItem.resolveSupport = {
        properties = {
          'documentation',
          'detail',
          'additionalTextEdits',
        }
      }
    '';
  };

  autoGroups = {
    lsp.clear = true;
    nix.clear = true;
  };

  autoCmd = [
    {
      event = [
        "BufWritePost"
        "BufEnter"
        "InsertLeave"
      ];
      pattern = "*";
      callback = { __raw =  "function() vim.diagnostic.setloclist({open = false}) end"; };
      group = "lsp";
    }
    {
      event = "FileType";
      pattern = [
        "nix"
      ];
      command = "set softtabstop=2 | set shiftwidth=2";
      group = "nix";
    }
  ];
}
    # lsp = {
    #   servers = {
    #     nil_ls.enable = true;
    #     lua_ls.enable = true;
    #     nixd.enable = true;
    #     rust_analyzer = {
    #       enable = true;
    #       installCargo = true;
    #       installRustc = true;
    #     };
    #   };
    # };

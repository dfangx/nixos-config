{ inputs, config, pkgs, ... }:
{
  imports = [
    inputs.nixneovim.nixosModules.default
  ];

  nixpkgs.overlays = [
    inputs.nixneovim.overlays.default
    inputs.nixneovimplugins.overlays.default
  ];

  home.packages = with pkgs; [
    nano
  ];

  programs.nixneovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    usePluginDefaults = true;
    defaultEditor = true;

    colorschemes.nord = {
      enable = true;
      borders = true;
      cursorline_transparent = true;
      disable_background = true;
      italic = true;
    };

    globals = {
      mapleader = " ";
      localmapleader = " ";
      netrw_liststyle = 3;
      netrw_winsize = 20;
      netrw_banner = 0;
      netrw_altv = 1;
      tex_flavor = "latex";
      netrw_browsex_viewer = "xdg-open";
      notes_home = "~/notes";
    };

    options = {
      autochdir = true;
      completeopt = "menuone,noinsert,noselect";
      cursorline = true;
      lazyredraw = true;
      showcmd = true;
      wildmenu = true;
      wildmode = "list:full,full";
      showmatch = true;
      showmode = true;
      pastetoggle = "<F1>";
      hidden = true;
      history = 1000;
      writebackup = true;
      backup = false;
      undofile = true;
      foldenable = true;
      foldlevelstart = 0;
      number = true;
      relativenumber = true;
      softtabstop = 4;
      shiftwidth = 4;
      expandtab = true;
      splitbelow = true;
      splitright = true;
      omnifunc = "syntaxcomplete#Complete";
      autoread = true;
      scrolloff = 1;
      sidescrolloff = 5;
      guicursor = "";
      ignorecase = true;
      smartcase = true;
      mouse = "";
      wildignore = "*.bmp,*.gif,*.ico,*.png,*.pdf,*.psd";
      tags = "./tags;,tags,.git/tags;/";
    };

    augroups = {
      vimStart = {
        clear = true;
        autocmds = [{
          event = "VimResized";
          pattern = "*";
          command = "wincmd =";
        }];
      };
      lsp = {
        clear = true;
        autocmds = [{
          event = [
            "BufWritePost"
            "BufEnter"
            "InsertLeave"
          ];
          pattern = "*";
          luaCallback = "vim.diagnostic.setloclist({open = false})";
        }];
      };
    };

    mappings = {
      normal = {
        # "<leader>ff" = 
        #   if fzf.enable then
        #     ":FzfLua files<cr>"
        #   else
        #     ":find";
        # "<leader>fs" = 
        #   if fzf.enable then
        #     ":FzfLua fzf.files({ actions = { [\\\"default\\\"] = fzfActions.file_split } })<cr>"
        #   else
        #     ":sfind";
        # "<leader>fv" = 
        #   if fzf.enable then
        #     ":FzfLua fzf.files({ actions = { [\\\"default\\\"] = fzfActions.file_vsplit } })<cr>"
        #   else
        #     ":vert :sfind";
        # "<leader>ft" = 
        #   if fzf.enable then
        #     ":FzfLua fzf.files({ actions = { [\\\"default\\\"] = fzfActions.file_tabedit } })<cr>"
        #   else
        #     ":tabfind";
        "<leader>ff" = if config.programs.nixneovim.plugins.telescope.enable then
          "':Telescope find_files<cr>'"
          else
            "':find<cr>'";
        "S" = "'a<cr><cr>'";
        "<leader>O" = "'O<esc>'";
        "<leader>o" = "'o<esc>'";
        "]b" = "':bn<cr>'";
        "[b" = "':bp<cr>'";
        # "<leader>bb" = 
        #   if fzf.enable then
        #     ":FzfLua buffers<cr>"
        #   else
        #     ":ls<cr>:b";
        "<leader>bb" = if config.programs.nixneovim.plugins.telescope.enable then
          "':Telescope buffers<cr>'"
          else
            "':ls<cr>:b<cr>'";
        "<leader>bd" = "':bd<cr>'";
        "<leader>h" = { 
          silent = true; 
          action = "'<c-w>H'"; 
        };
        "<leader>l" = { 
          silent = true; 
          action = "'<c-w>L'"; 
        };
        "<leader>j" = { 
          silent = true;
          action = "'<c-w>J'";
        };
        "<leader>k" = { 
          silent = true; 
          action = "'<c-w>K'"; 
        };
        "<leader>s" = "'<c-w>s'";
        "<leader>v" = "'<c-w>v'";
        "<leader><" = { 
          silent = true; 
          action = "'10<c-w><'"; 
        };
        "<leader>>" = { 
          silent = true;
          action = "'10<c-w>>'";
        };
        "<leader>+" = { 
          silent = true; 
          action = "'10<c-w>+'";
        };
        "<leader>-" = { 
          silent = true; 
          action = "'10<c-w>-'"; 
        };
        "<c-j>" = "'<c-w>j'";
        "<c-k>" = "'<c-w>k'";
        "<c-l>" = "'<c-w>l'";
        "<c-h>" = "'<c-w>h'";
        "<space>" = "'<noop>'";
        "<leader>e" = "'<cmd>Lexplore<cr>'";
      };
    };

    plugins = {
      nvim-cmp = {
        enable = true;
        completion = {
          completeopt = "menuone,noinsert,noselect";
        };
        mapping = {
          "<TAB>" = "cmp.mapping.select_next_item()";
          "<S-TAB>" = "cmp.mapping.select_prev_item()";
          "<C-e>" = "cmp.mapping.abort()";
          "<CR>" = "cmp.mapping.confirm({ select = true })";
        };
        sources = {
          buffer.enable = true;
          calc.enable = true;
          # cmdline.enable = true;
          # cmp-cmdline-history.enable = true;
          luasnip.enable = true;
          nvim_lsp.enable = true;
          nvim_lsp_document_symbol.enable = true;
          nvim_lsp_signature_help.enable = true;
          nvim_lua.enable = true;
          omni.enable = true;
          path.enable = true;
          treesitter.enable = true;
        };
        snippet.luasnip.enable = true;
      };
      lualine = {
        enable = true;
      };
      lspconfig = {
        enable = true;
        servers.nil = {
          enable = true;
          extraConfig = "capabilities = capabilities";
        };
        onAttach = ''
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
          vim.api.nvim_buf_set_keymap(0, 'n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
          vim.api.nvim_buf_set_keymap(0, 'n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
          vim.api.nvim_buf_set_keymap(0, 'n', 'gc', '<cmd>lua vim.lsp.buf.incoming_calls()<cr>', opts)
          vim.api.nvim_buf_set_keymap(0, 'n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
          vim.api.nvim_buf_set_keymap(0, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
          vim.api.nvim_buf_set_keymap(0, 'n', '<C-s>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
          vim.api.nvim_buf_set_keymap(0, 'n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
          vim.api.nvim_buf_set_keymap(0, 'n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
          vim.api.nvim_buf_set_keymap(0, 'n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
          vim.api.nvim_buf_set_keymap(0, 'n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
          vim.api.nvim_buf_set_keymap(0, 'n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
          vim.api.nvim_buf_set_keymap(0, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
          vim.api.nvim_buf_set_keymap(0, 'n', '<leader>E', '<cmd>lua vim.lsp.diagnostic.open_float()<CR>', opts)
          vim.api.nvim_buf_set_keymap(0, 'n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
          vim.api.nvim_buf_set_keymap(0, 'n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
          vim.api.nvim_buf_set_keymap(0, 'n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
          vim.api.nvim_buf_set_keymap(0, 'n', 'ga', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
        '';
        preConfig = ''
          local capabilities = require('cmp_nvim_lsp').default_capabilities();
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
      luasnip = {
        enable = true;
      };
      nvim-autopairs = {
        enable = true;
      };
      treesitter = {
        enable = true;
        folding = true;
        installAllGrammars = true;
        refactor = {
          highlightCurrentScope.enable = true;
          highlightDefinitions.enable = true;
        };
      };
      plenary.enable = true;
      telescope = {
        enable = true;
      };
    };

    extraPlugins = with pkgs; [
      vimExtraPlugins.mkdnflow-nvim
      vimPlugins.vim-pencil
    ];

    extraConfigLua = ''
      require('mkdnflow').setup({
        wrap = true,
        links = {
          conceal = true,
        },
      })
    '';

    extraConfigVim = ''
      let g:pencil#wrapModeDefault = 'soft'   " default is 'hard'
      augroup pencil
        autocmd!
        autocmd FileType markdown,mkd call pencil#init()
        autocmd FileType text         call pencil#init()
      augroup END
    '';
  };
}

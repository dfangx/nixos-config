{ inputs, config, pkgs, ... }:
{
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
  ];

  # nixpkgs.overlays = [
  #   inputs.nixneovim.overlays.default
  #   inputs.nixneovimplugins.overlays.default
  # ];

  home.packages = with pkgs; [
    nano
  ];

  programs.nixvim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    defaultEditor = true;

    colorschemes.nord = {
      enable = true;
      settings = {
        borders = true;
        cursorline_transparent = true;
        disable_background = true;
        italic = true;
      };
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

    autoCmd = [
      {
        event = "VimResized";
        pattern = "*";
        command = "wincmd =";
        group = "vimStart";
      }
      {
        event = [
          "BufWritePost"
          "BufEnter"
          "InsertLeave"
        ];
        pattern = "*";
        callback = "vim.diagnostic.setloclist({open = false})";
        group = "lsp";
      }
    ];
    autoGroups = {
      vimStart.clear = true;
      lsp.clear = true;
    };

    keymaps = [
      {
        mode = "n";
        key = "<leader>ff"; 
        action = if config.programs.nixvim.plugins.telescope.enable then
          "':Telescope find_files<cr>'"
          else
            "':find<cr>'";
      }
      {
        key = "S";
        action = "'a<cr><cr>'";
      }
      {
        key = "<leader>O";
        action = "'O<esc>'";
      }
      {
        key = "<leader>o";
        action = "'o<esc>'";
      }
      {
        key = "]b";
        action = "':bn<cr>'";
      }
      {
        key = "[b";
        action = "':bp<cr>'";
      }
      {
        key = "<leader>bb";
        action = if config.programs.nixvim.plugins.telescope.enable then
          "':Telescope buffers<cr>'"
          else
            "':ls<cr>:b<cr>'";
      }
      {
        key = "<leader>bd";
        action = "':bd<cr>'";
      }
      {
        key = "<leader>h";
        action = "'<c-w>H'"; 
        options.silent = true; 
      }
      {
        key = "<leader>l";
        action = "'<c-w>L'"; 
        options.silent = true; 
      }
      {
        key = "<leader>j";
        action = "'<c-w>J'";
        options.silent = true;
      }
      {
        key = "<leader>k";
        action = "'<c-w>K'"; 
        options.silent = true; 
      }
      {
        key = "<leader>s";
        action = "'<c-w>s'";
      }
      {
        key = "<leader>v";
        action = "'<c-w>v'";
      }
      {
        key = "<leader><";
        action = "'10<c-w><'"; 
        options.silent = true; 
      }
      {
        key = "<leader>>";
        action = "'10<c-w>>'";
        options.silent = true;
      }
      {
        key = "<leader>+";
        action = "'10<c-w>+'";
        options.silent = true; 
      }
      {
        key = "<leader>-";
        action = "'10<c-w>-'"; 
        options.silent = true; 
      }
      {
        key = "<c-j>";
        action = "'<c-w>j'";
      }
      {
        key = "<c-k>";
        action = "'<c-w>k'";
      }
      {
        key = "<c-l>";
        action = "'<c-w>l'";
      }
      {
        key = "<c-h>";
        action = "'<c-w>h'";
      }
      {
        key = "<space>";
        action = "'<noop>'";
      }
      {
        key = "<leader>e";
        action = "'<cmd>Lexplore<cr>'";
      }
    ];
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
        # "<leader>bb" = 
        #   if fzf.enable then
        #     ":FzfLua buffers<cr>"
        #   else
        #     ":ls<cr>:b";

    plugins = {
      cmp = {
        enable = true;
        autoEnableSources = true;
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
          sources = [
            {
              name = "buffer";
            }
            {
              name = "calc";
            }
            {
              name = "cmdline";
            }
            {
              name = "cmp-cmdline-history";
            }
            {
              name = "luasnip";
            }
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
          snippet.expand = ''
            function(args)
              require('luasnip').lsp_expand(args.body)
            end
          '';
        };
      };
      lualine = {
        enable = true;
      };
      lsp = {
        enable = true;
        keymaps = {
          silent = true;
          diagnostic = {
            "<leader>E" = "open_float";
            "[d" = "goto_prev";
            "]d" = "goto_next";
            "<space>q" = "set_loclist";
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
        enabledServers = [
          {
            name = "nil-ls";
            extraOptions = {};
          }
        ];
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
          vim.api.nvim_buf_set_keymap(0, 'n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
        '';
        capabilities = ''
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
        ensureInstalled = "all";
        indent = true;
      };
      treesitter-refactor.enable = true;
      # plenary.enable = true;
      telescope = {
        enable = true;
      };
      mkdnflow.enable = true;
    };

    extraPlugins = with pkgs; [
      vimPlugins.vim-pencil
    ];

    extraConfigLua = ''
      require('mkdnflow').setup({
        wrap = true,
        links = {
          conceal = true,
        },
      })
      vim.filetype.add({
        pattern = { [".*/hypr/.*%.conf"] = "hyprlang" },
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

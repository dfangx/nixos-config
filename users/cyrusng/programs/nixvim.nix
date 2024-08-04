{ inputs, config, pkgs, ... }:
{
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
  ];

  home.packages = with pkgs; [
    nano
    nerdfonts # For neorg
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

    opts = {
      autochdir = true;
      completeopt = "menuone,noinsert,noselect";
      cursorline = true;
      lazyredraw = true;
      showcmd = true;
      wildmenu = true;
      wildmode = "list:full,full";
      showmatch = true;
      showmode = true;
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
        callback = { __raw =  "function() vim.diagnostic.setloclist({open = false}) end"; };
        group = "lsp";
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
      {
        event = "FileType";
        pattern = [
          "markdown"
          "mkd"
          "text"
          "norg"
        ];
        command = "call pencil#init()";
        group = "pencil";
      }
    ];
    autoGroups = {
      vimStart.clear = true;
      lsp.clear = true;
      pencil.clear = true;
      # zen-mode.clear = true;
    };

    keymaps = [
      {
        mode = "n";
        key = "S";
        action = "a<cr><cr>";
      }
      {
        mode = "n";
        key = "<leader>O";
        action = "O<esc>";
      }
      {
        mode = "n";
        key = "<leader>o";
        action = "o<esc>";
      }
      {
        mode = "n";
        key = "]b";
        action = ":bn<cr>";
      }
      {
        mode = "n";
        key = "[b";
        action = ":bp<cr>";
      }
      {
        mode = "n";
        key = "<leader>bd";
        action = ":bd<cr>";
      }
      {
        mode = "n";
        key = "<leader>h";
        action = "<c-w>H"; 
        options.silent = true; 
      }
      {
        mode = "n";
        key = "<leader>l";
        action = "<c-w>L"; 
        options.silent = true; 
      }
      {
        mode = "n";
        key = "<leader>j";
        action = "<c-w>J";
        options.silent = true;
      }
      {
        mode = "n";
        key = "<leader>k";
        action = "<c-w>K"; 
        options.silent = true; 
      }
      {
        mode = "n";
        key = "<leader>s";
        action = "<c-w>s";
      }
      {
        mode = "n";
        key = "<leader>v";
        action = "<c-w>v";
      }
      {
        mode = "n";
        key = "<leader><";
        action = "10<c-w><"; 
        options.silent = true; 
      }
      {
        mode = "n";
        key = "<leader>>";
        action = "10<c-w>>";
        options.silent = true;
      }
      {
        mode = "n";
        key = "<leader>+";
        action = "10<c-w>+";
        options.silent = true; 
      }
      {
        mode = "n";
        key = "<leader>-";
        action = "10<c-w>-"; 
        options.silent = true; 
      }
      {
        mode = "n";
        key = "<c-j>";
        action = "<c-w>j";
      }
      {
        mode = "n";
        key = "<c-k>";
        action = "<c-w>k";
      }
      {
        mode = "n";
        key = "<c-l>";
        action = "<c-w>l";
      }
      {
        mode = "n";
        key = "<c-h>";
        action = "<c-w>h";
      }
      {
        mode = "n";
        key = "<space>";
        action = "<noop>";
      }
      {
        mode = "n";
        key = "<leader>e";
        action = "<cmd>Lexplore<cr>";
      }
      {
        mode = "n"; 
        key = "<space>q";
        action = { __raw = "function() vim.diagnostic.setloclist() end"; };
      }
    ];
    plugins = {
      zen-mode = {
        enable = true;
      };
      fzf-lua = {
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
          sources = [
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
        servers = {
          nil-ls.enable = true;
          lua-ls.enable = true;
          nixd.enable = true;
          clangd.enable = true;
          rust-analyzer = {
            enable = true;
            installCargo = true;
            installRustc = true;
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
      luasnip = {
        enable = true;
      };
      nvim-autopairs = {
        enable = true;
      };
      treesitter = {
        enable = true;
        folding = true;
        settings = {
          ensure_installed = "all";
          indent.enable = true;
        };
      };
      treesitter-refactor.enable = true;
      mkdnflow = {
        enable = true;
        wrap = true;
        links.conceal = true;
      };
      neorg = {
        enable = false;
        modules = {
          "core.defaults" = { __empty = null; };
          "core.dirman" = {
            config = {
              workspaces = {
                notes = "~/notes";
              };
            };
          };
          "core.esupports.metagen" = {
            config = {
              type = "auto";
            };
          };
          "core.concealer" = { __empty = null;  };
          "core.manoeuvre" = { __empty = null;  };
          "core.summary" = { __empty = null;  };
        };
      };
    };

    filetype.pattern = { 
      ".*/hypr/.*%.conf" = "hyprlang";
    };
    extraPlugins = with pkgs; [
      vimPlugins.vim-pencil
    ];

    extraConfigLua = ''
    '';

    extraConfigVim = /*vim*/''
      let g:pencil#wrapModeDefault = 'soft'   " default is 'hard'
    '';
  };
}

{ inputs, pkgs, ... }:
{
  imports = [
    inputs.nixneovim.nixosModules.default
  ];

  nixpkgs.overlays = [
    inputs.nixneovim.overlays.default
  ];

  home.packages = with pkgs; [
    nano
  ];

  programs.nixneovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    usePluginDefaults = true;
    colorscheme = "nord";
    colorschemes.nord = {
      enable = true;
      borders = true;
      cursorline_transparent = true;
      disable_background = true;
      italic = true;
    };
    defaultEditor = true;
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
        "<leader>bd" = ":bd<cr>";
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
          action = "10<c-w><"; 
        };
        "<leader>>" = { 
          silent = true;
          action = "10<c-w>>";
        };
        "<leader>+" = { 
          silent = true; 
          action = "10<c-w>+";
        };
        "<leader>-" = { 
          silent = true; 
          action = "10<c-w>-"; 
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
          cmdline.enable = true;
          cmp-cmdline-history.enable = true;
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
      # luasnip = {
      #   enable = true;
      # };
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
  };
}

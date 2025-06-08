{
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
}

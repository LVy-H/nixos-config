{ pkgs, ... }:

{
  programs.nixvim = {
    enable = true;
    defaultEditor = true;

    # Colorscheme
    colorschemes.catppuccin = {
      enable = true;
      settings.flavour = "macchiato";
    };

    # Keymaps (Space as leader)
    globals.mapleader = " ";
    keymaps = [
      { mode = "n"; key = "<leader>e"; action = "<cmd>Neotree toggle<CR>"; options.desc = "Toggle Explorer"; }
      { mode = "n"; key = "<leader>ff"; action = "<cmd>Telescope find_files<CR>"; options.desc = "Find Files"; }
      { mode = "n"; key = "<leader>fg"; action = "<cmd>Telescope live_grep<CR>"; options.desc = "Grep Files"; }
      { mode = "n"; key = "<leader>b"; action = "<cmd>Telescope buffers<CR>"; options.desc = "Find Buffers"; }
    ];

    # Options
    opts = {
      number = true;         # Show line numbers
      relativenumber = true; # Relative line numbers
      shiftwidth = 2;        # Tab width should be 2
      tabstop = 2;
      expandtab = true;      # Use spaces instead of tabs
      smartindent = true;
      clipboard = "unnamedplus"; # Use system clipboard
    };

    # Plugins
    plugins = {
      lualine.enable = true; # Status bar
      web-devicons.enable = true; # Required for icons
      
      # File Explorer
      neo-tree = {
        enable = true;
        settings = {
            close_if_last_window = true;
        };
      };

      # Fuzzy Finder
      telescope = {
        enable = true;
        keymaps = {
          "<C-p>" = "find_files";
          "<leader>/" = "live_grep";
        };
      };

      # Syntax Highlighting
      treesitter = {
        enable = true;
        settings.indent.enable = true;
      };

      # LSP (Language Server Protocol)
      lsp = {
        enable = true;
        servers = {
          # Nix
          nixd.enable = true;
          # Python
          pyright.enable = true;
          # Go
          gopls.enable = true;
          # Bash
          bashls.enable = true;
        };
      };

      # Autocomplete
      cmp = {
        enable = true;
        autoEnableSources = true;
        settings = {
          mapping = {
            "<C-Space>" = "cmp.mapping.complete()";
            "<CR>" = "cmp.mapping.confirm({ select = true })";
            "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
            "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
          };
          sources = [
            { name = "nvim_lsp"; }
            { name = "path"; }
            { name = "buffer"; }
          ];
        };
      };
      
      # Git
      gitsigns.enable = true;
      
      # Auto-pairs (brackets)
      nvim-autopairs.enable = true;
    };
  };
}
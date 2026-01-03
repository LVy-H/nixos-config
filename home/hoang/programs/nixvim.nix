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

    # Plugins
    plugins = {
      lualine.enable = true; # Status bar
      web-devicons.enable = true; # Required for icons
      
      # Helper for keybindings
      which-key = {
        enable = true;
      };

      # Comments
      comment.enable = true;
      todo-comments.enable = true;

      # Diagnostics
      trouble.enable = true;

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
      lazygit.enable = true;
      
      # Auto-pairs (brackets)
      nvim-autopairs.enable = true;
      
      # UI Improvements
      indent-blankline = {
        enable = true;
        settings = {
          scope.enabled = true;
        };
      };
    };
    
    # Keymaps (Space as leader)
    globals.mapleader = " ";
    keymaps = [
      { mode = "n"; key = "<leader>e"; action = "<cmd>Neotree toggle<CR>"; options.desc = "Toggle Explorer"; }
      { mode = "n"; key = "<leader>ff"; action = "<cmd>Telescope find_files<CR>"; options.desc = "Find Files"; }
      { mode = "n"; key = "<leader>fg"; action = "<cmd>Telescope live_grep<CR>"; options.desc = "Grep Files"; }
      { mode = "n"; key = "<leader>b"; action = "<cmd>Telescope buffers<CR>"; options.desc = "Find Buffers"; }
      { mode = "n"; key = "<leader>x"; action = "<cmd>Trouble diagnostics toggle<CR>"; options.desc = "Diagnostics (Trouble)"; }
      { mode = "n"; key = "<leader>t"; action = "<cmd>TodoTelescope<CR>"; options.desc = "Find TODOs"; }
    ];
  };
}
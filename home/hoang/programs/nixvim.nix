{ pkgs, ... }:

{
  programs.nixvim = {
    enable = true;
    defaultEditor = true;

    # Colorscheme (Handled by Stylix)

    # Editor Options
    opts = {
      number = true;
      relativenumber = true;
      expandtab = true;
      tabstop = 2;
      shiftwidth = 2;
      softtabstop = 2;
      smartindent = true;
      cursorline = true;
      scrolloff = 8;
      signcolumn = "yes";
      termguicolors = true;
      showmode = false;
      undofile = true;
      swapfile = false;
      ignorecase = true;
      smartcase = true;
      splitright = true;
      splitbelow = true;
      updatetime = 100;
    };

    # Plugins
    plugins = {
      lualine.enable = true;
      web-devicons.enable = true;

      bufferline = {
        enable = true;
        settings.options = {
          diagnostics = "nvim_lsp";
          offsets = [
            {
              filetype = "neo-tree";
              text = "Explorer";
              highlight = "Directory";
              text_align = "center";
            }
          ];
        };
      };

      which-key = {
        enable = true;
      };

      comment.enable = true;
      todo-comments.enable = true;

      # Diagnostics
      trouble.enable = true;

      neo-tree = {
        enable = true;
        settings = {
          close_if_last_window = true;
        };
      };

      telescope = {
        enable = true;
        keymaps = {
          "<C-p>" = "find_files";
          "<leader>/" = "live_grep";
        };
      };

      lorem-nvim = {
        enable = true;
        settings = {
          sentence_length = {
            w_per_sentence = 15;
          };
          comma_chance = 0.2;
        };
      };

      treesitter = {
        enable = true;
        highlight.enable = true;
        indent.enable = true;
      };

      conform-nvim = {
        enable = true;
        settings = {
          format_on_save = {
            lsp_format = "fallback";
            timeout_ms = 500;
          };
          formatters_by_ft = {
            nix = [ "nixfmt" ];
            python = [
              "black"
              "isort"
            ];
            go = [ "gofmt" ];
            bash = [ "shfmt" ];
            "_" = [ "trim_whitespace" ];
          };
        };
      };

      lsp = {
        enable = true;
        servers = {
          nixd.enable = true;
          pyright.enable = true;
          gopls.enable = true;
          bashls.enable = true;
          clangd.enable = true;
          basedpyright.enable = true;
          ruff.enable = true;
        };
        keymaps = {
          silent = true;
          diagnostic = {
            "<leader>j" = {
              action = "goto_next";
              desc = "Next Diagnostic";
            };
            "<leader>k" = {
              action = "goto_prev";
              desc = "Prev Diagnostic";
            };
          };
          lspBuf = {
            K = {
              action = "hover";
              desc = "Hover";
            };
            gd = {
              action = "definition";
              desc = "Go to Definition";
            };
            gD = {
              action = "declaration";
              desc = "Go to Declaration";
            };
            gr = {
              action = "references";
              desc = "References";
            };
            gi = {
              action = "implementation";
              desc = "Implementation";
            };
            "<leader>rn" = {
              action = "rename";
              desc = "Rename";
            };
            "<leader>ca" = {
              action = "code_action";
              desc = "Code Action";
            };
          };
        };
      };

      # Snippet engine
      luasnip = {
        enable = true;
        fromVscode = [ { } ];
      };
      friendly-snippets.enable = true;

      cmp = {
        enable = true;
        autoEnableSources = true;
        settings = {
          snippet.expand = "function(args) require('luasnip').lsp_expand(args.body) end";
          mapping = {
            "<C-Space>" = "cmp.mapping.complete()";
            "<CR>" = "cmp.mapping.confirm({ select = false })";
            "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
            "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
          };
          sources = [
            { name = "nvim_lsp"; }
            { name = "luasnip"; }
            { name = "path"; }
            { name = "buffer"; }
          ];
        };
      };

      gitsigns.enable = true;
      lazygit.enable = true;

      nvim-autopairs.enable = true;

      indent-blankline = {
        enable = true;
        settings = {
          scope.enabled = true;
        };
      };

      # UI Enhancements
      noice = {
        enable = true;
        settings = {
          lsp.override = {
            "vim.lsp.util.convert_input_to_markdown_lines" = true;
            "vim.lsp.util.stylize_markdown" = true;
            "cmp.entry.get_documentation" = true;
          };
          presets = {
            bottom_search = true;
            command_palette = true;
            long_message_to_split = true;
            lsp_doc_border = true;
          };
        };
      };

      fidget = {
        enable = true;
        settings.notification.window.winblend = 0;
      };

      illuminate = {
        enable = true;
        settings = {
          delay = 200;
          providers = [
            "lsp"
            "treesitter"
          ];
          filetypes_denylist = [
            "neo-tree"
            "TelescopePrompt"
          ];
          under_cursor = true;
          min_count_to_highlight = 2;
        };
      };

      colorizer = {
        enable = true;
        settings = {
          filetypes = {
            __unkeyed-1 = "*";
            __unkeyed-2 = "!neo-tree";
          };
          user_default_options = {
            names = false;
            RGB = true;
            RRGGBB = true;
            RRGGBBAA = true;
            css = true;
            css_fn = true;
            mode = "virtualtext";
            virtualtext = "■";
            virtualtext_inline = true;
          };
        };
      };
    };

    # Keymaps (Space as leader)
    globals.mapleader = " ";
    keymaps = [
      {
        mode = "n";
        key = "<leader>e";
        action = "<cmd>Neotree toggle<CR>";
        options.desc = "Toggle Explorer";
      }
      {
        mode = "n";
        key = "<leader>ff";
        action = "<cmd>Telescope find_files<CR>";
        options.desc = "Find Files";
      }
      {
        mode = "n";
        key = "<leader>fg";
        action = "<cmd>Telescope live_grep<CR>";
        options.desc = "Grep Files";
      }
      {
        mode = "n";
        key = "<leader>b";
        action = "<cmd>Telescope buffers<CR>";
        options.desc = "Find Buffers";
      }
      {
        mode = "n";
        key = "<leader>x";
        action = "<cmd>Trouble diagnostics toggle<CR>";
        options.desc = "Diagnostics (Trouble)";
      }
      {
        mode = "n";
        key = "<leader>t";
        action = "<cmd>TodoTelescope<CR>";
        options.desc = "Find TODOs";
      }
      {
        mode = "n";
        key = "<leader>li";
        action = "<cmd>LoremIpsum paragraphs 1<CR>";
        options.desc = "Insert Lorem Ipsum";
      }
      # Buffer navigation
      {
        mode = "n";
        key = "<S-h>";
        action = "<cmd>BufferLineCyclePrev<cr>";
        options.desc = "Prev Buffer";
      }
      {
        mode = "n";
        key = "<S-l>";
        action = "<cmd>BufferLineCycleNext<cr>";
        options.desc = "Next Buffer";
      }
      {
        mode = "n";
        key = "<leader>bd";
        action = "<cmd>bdelete<cr>";
        options.desc = "Close Buffer";
      }
    ];
  };
}

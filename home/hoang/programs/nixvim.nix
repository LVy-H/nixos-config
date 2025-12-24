{pkgs, ...}: {
  programs.nixvim = {
    enable = true;
    defaultEditor = true;

    colorschemes.catppuccin.enable = true;

    opts = {
      number = true;
      relativenumber = true;
      shiftwidth = 2;
      tabstop = 2;
      expandtab = true;
      clipboard = "unnamedplus";
    };

    globals.mapleader = " ";

    keymaps = [
      {
        key = "<leader>e";
        action = "<cmd>Neotree toggle<CR>";
        options.desc = "Toggle Explorer";
      }
      {
        key = "<leader>ff";
        action = "<cmd>Telescope find_files<CR>";
        options.desc = "Find files";
      }
      {
        key = "<leader>fg";
        action = "<cmd>Telescope live_grep<CR>";
        options.desc = "Live grep";
      }
    ];

    plugins = {
      dashboard.enable = true;
      lualine.enable = true;
      neo-tree.enable = true;
      telescope.enable = true;
      treesitter = {
        enable = true;
        settings.highlight.enable = true;
      };
      gitsigns.enable = true;
      
      luasnip.enable = true;
      
      cmp-nvim-lsp.enable = true;
      cmp-path.enable = true;
      cmp-buffer.enable = true;
      cmp-luasnip.enable = true;

      cmp = {
        enable = true;
        autoEnableSources = true;
        settings = {
          sources = [
            { name = "nvim_lsp"; }
            { name = "path"; }
            { name = "buffer"; }
            { name = "luasnip"; }
          ];
          mapping = {
            "<C-Space>" = "cmp.mapping.complete()";
            "<CR>" = "cmp.mapping.confirm({select = true})";
            "<Tab>" = {
              __raw = ''
                cmp.mapping(function(fallback)
                  if cmp.visible() then
                    cmp.select_next_item()
                  elseif require('luasnip').expand_or_jumpable() then
                    require('luasnip').expand_or_jump()
                  else
                    fallback()
                  end
                end, {'i', 's'})
              '';
            };
            "<S-Tab>" = {
              __raw = ''
                cmp.mapping(function(fallback)
                  if cmp.visible() then
                    cmp.select_prev_item()
                  elseif require('luasnip').jumpable(-1) then
                    require('luasnip').jump(-1)
                  else
                    fallback()
                  end
                end, {'i', 's'})
              '';
            };
          };
        };
      };

      lsp = {
        enable = true;
        servers = {
          nixd.enable = true;
          pyright.enable = true;
          lua_ls.enable = true;
        };
        keymaps = {
          silent = true;
          lspBuf = {
            gd = "definition";
            gD = "references";
            K = "hover";
            "<leader>rn" = "rename";
            "<leader>ca" = "code_action";
          };
        };
      };
    };
  };
}

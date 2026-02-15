-- ~/.config/nvim/init.lua
-- Set up plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Minimal plugins for auto-import
require("lazy").setup({
  -- LSP for TypeScript/JavaScript
	spec = {
		-- import your plugins
		{ import = "plugins" },
	},
	-- -- Configure any other settings here. See the documentation for more details.
	-- -- colorscheme that will be used when installing plugins.
	-- install = { colorscheme = { "habamax" } },
	-- -- automatically check for plugin updates
	-- checker = { enabled = true },
  {
    "neovim/nvim-lspconfig",
    config = function()
      -- Use the new vim.lsp.config API (not deprecated)
      vim.lsp.config["ts_ls"] = {
        cmd = { "typescript-language-server", "--stdio" },
        root_markers = { "package.json", "tsconfig.json", "jsconfig.json" },
        filetypes = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
        capabilities = {
          textDocument = {
            completion = {
              completionItem = {
                snippetSupport = true,
                commitCharactersSupport = true,
                deprecatedSupport = true,
                preselectSupport = true,
                tagSupport = { valueSet = { 1 } },
                insertReplaceSupport = true,
                resolveSupport = {
                  properties = { "documentation", "detail", "additionalTextEdits" },
                },
              },
            },
          },
        },
        init_options = {
          preferences = {
            includeCompletionsForModuleExports = true,
            includeCompletionsWithInsertText = true,
            autoImportFileExcludePatterns = {},
            importModuleSpecifierPreference = "relative",
          },
        },
      }
      
      -- Enable the LSP
      vim.lsp.enable("ts_ls")
    end,
  },
  
  -- Autocompletion
  -- {
  --   "hrsh7th/nvim-cmp",
  --   dependencies = {
  --     "hrsh7th/cmp-nvim-lsp",
  --   },
  --   config = function()
  --     local cmp = require("cmp")
  --
  --     cmp.setup({
  --       snippet = {
  --         expand = function(args)
  --           -- No snippet engine needed for basic completion
  --           vim.api.nvim_command(string.format('i<C-G>u%s', args.body))
  --         end,
  --       },
  --       mapping = {
  --         ['<Tab>'] = cmp.mapping(function(fallback)
  --           if cmp.visible() then
  --             cmp.select_next_item()
  --           else
  --             fallback()
  --           end
  --         end, { 'i', 's' }),
  --         ['<CR>'] = cmp.mapping.confirm({ select = true }),
  --       },
  --       sources = {
  --         { name = 'nvim_lsp' },
  --       },
  --     })
  --   end,
  -- },
  
  -- Simple LSP installer
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    config = true,
  },
  "williamboman/mason-lspconfig.nvim",
})

-- Basic settings
vim.opt.completeopt = { "menu", "menuone", "noselect" }


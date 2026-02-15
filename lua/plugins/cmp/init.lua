  return {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local cmp = require("cmp")

      cmp.setup({
        snippet = {
          expand = function(args)
            -- No snippet engine needed for basic completion
            vim.api.nvim_command(string.format('i<C-G>u%s', args.body))
          end,
        },
        mapping = {
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
        },
        sources = {
          { name = 'nvim_lsp' },
        },
      })
    end,
  }


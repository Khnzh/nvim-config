-- COPYING TO + REGISTRY
vim.o.clipboard = "unnamedplus"
-- IGNORING CASE WHEN SEARCHING PATTERNS
vim.opt.ignorecase = true
-- SET INDENTATIONS TO 4
vim.opt.tabstop = 4 -- Number of spaces that a <Tab> in the file counts for
vim.opt.softtabstop = 4 -- Number of spaces that a <Tab> counts for while performing editing operations
vim.opt.shiftwidth = 4 -- Number of spaces to use for each step of (auto)indent
vim.opt.expandtab = true -- Use spaces instead of tabs
vim.opt.smartindent = true
vim.opt.autoindent = true
vim.api.nvim_set_option_value("relativenumber", true, {})
-- SOME AUTOCOMPLETE OPTS
vim.opt.completeopt = { "menu", "menuone", "noselect" }

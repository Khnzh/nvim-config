-- DISABLE BUILT-IN SQL OMNICOMPLETION (causes dbext errors)
vim.g.omni_sql_no_default_maps = 1

-- SET DB FOR ALL SQL BUFFERS (vim-dadbod-completion)
local db_connections = {}
for _, conn in ipairs(require("config.db")) do
	if conn.dadbod_name then
		db_connections[conn.dadbod_name] = conn.url
	end
end

local function select_db_connection(callback)
	local choices = { "None" }
	for name, _ in pairs(db_connections) do
		table.insert(choices, name)
	end
	vim.ui.select(choices, { prompt = "Select DB connection:" }, function(choice)
		if choice and choice ~= "None" then
			vim.g.db = db_connections[choice]
		end
		if callback then callback() end
	end)
end

vim.api.nvim_create_autocmd("FileType", {
	pattern = "sql",
	callback = function()
		if vim.bo.buftype ~= "" then return end
		if vim.g.db then
			vim.b.db = vim.g.db
		else
			select_db_connection(function()
				vim.b.db = vim.g.db
			end)
		end
	end,
})

vim.keymap.set("n", "<leader>dc", function()
	select_db_connection(function()
		vim.b.db = vim.g.db
	end)
end, { desc = "Change DB connection" })

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

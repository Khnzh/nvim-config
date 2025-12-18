function ShowInBuffer(title, content)
	local buf = vim.api.nvim_create_buf(false, true)
	local width = math.floor(vim.o.columns * 0.8)
	local height = math.floor(vim.o.lines * 0.8)

	vim.api.nvim_open_win(buf, true, {
		relative = 'editor',
		width = width,
		height = height,
		col = math.floor((vim.o.columns - width) / 2),
		row = math.floor((vim.o.lines - height) / 2),
		style = 'minimal',
		border = 'rounded'
	})

	-- Format content
	local lines = {}
	if type(content) == 'string' then
		lines = vim.split(content, '\n')
	elseif type(content) == 'table' then
		lines = {vim.inspect(content)}
	else
		lines = {tostring(content)}
	end

	-- Add title
	table.insert(lines, 1, "=== " .. title .. " ===")
	table.insert(lines, 2, "")

	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
	vim.api.nvim_buf_set_option(buf, 'modifiable', false)

	-- Add keymaps to close
	vim.keymap.set('n', 'q', '<cmd>q!<CR>', {buffer = buf})
	vim.keymap.set('n', '<Esc>', '<cmd>q!<CR>', {buffer = buf})
end

-- Usage
-- disable netrw at the very start of your init.lua
local function my_on_attach(bufnr)
	local api = require("nvim-tree.api")
	local telescope = require("telescope.builtin")
	local DirectoryNode = require("nvim-tree.node.directory")
	local function opts(desc)
		return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
	end

	api.config.mappings.default_on_attach(bufnr)

	vim.keymap.set('n', '<leader>e', function ()
		api.tree.toggle({ path = "", find_file = true, update_root = false, focus = true, })
	end,
	{
		desc = "Go to parent directory",
		noremap = true,
		silent = true,
		nowait = true,
	}
)



vim.keymap.set('n', 'f', function ()
	local node = api.tree.get_node_under_cursor()
	local dir =node:as(DirectoryNode)
	local path = ""
	if dir then
		path = dir.absolute_path
	else path = node.absolute_path
		path = vim.fn.fnamemodify(path, ":h")
	end
	vim.print(path)
	telescope.find_files({cwd = path})
end,
{
	buffer = bufnr,  -- KEY: Makes it buffer-local
	desc = "Go to parent directory",
	noremap = true,
	silent = true,
	nowait = true,
}
		)


vim.keymap.set('n', '<leader>/', function ()
	local node = api.tree.get_node_under_cursor()
	local dir =node:as(DirectoryNode)
	local path = ""
	if dir then
		path = dir.absolute_path
	else path = node.absolute_path
		path = vim.fn.fnamemodify(path, ":h")
	end
	vim.print(path)
	telescope.live_grep({cwd = path})
end,
{
	buffer = bufnr,  -- KEY: Makes it buffer-local
	desc = "Go to parent directory",
	noremap = true,
	silent = true,
	nowait = true,
}
		)
	end



	vim.g.loaded_netrw = 1
	vim.g.loaded_netrwPlugin = 1
	vim.opt.termguicolors = true



	require("nvim-tree").setup({
		sort = {
			sorter = "case_sensitive",
		},
		view = {
			width = 30,
		},
		renderer = {
			group_empty = true,
		},
		filters = {
			dotfiles = true,
		},
		on_attach = my_on_attach
	})


-- CENTERING WHEN JUMPING TO OCCURENCES (n always forward, N always backward)
vim.keymap.set("n", "n", "'Nn'[v:searchforward] .. 'zz'", { expr = true, noremap = true, silent = true })
vim.keymap.set("n", "N", "'nN'[v:searchforward] .. 'zz'", { expr = true, noremap = true, silent = true })
-- DELETING ALL ROWS WITH SPECIFIC OCCURENCE
vim.keymap.set("n", "<Leader>dd", ":g/<C-r><C-w>/d<CR>")
--
--
-- Quickfix for all workspace diagnostics
vim.keymap.set("n", "<leader>q", function()
	vim.diagnostic.setqflist()
	if #vim.fn.getqflist() > 0 then
		vim.cmd("copen") -- Automatically open quickfix window
	else
		print("No diagnostics found")
	end
end, { desc = "Open quickfix with all diagnostics" })
--
--
-- Location list for current buffer only
vim.keymap.set("n", "<leader>ql", function()
	vim.diagnostic.setloclist()
	if #vim.fn.getloclist(0) > 0 then
		vim.cmd("lopen") -- Automatically open location list
	else
		print("No diagnostics found")
	end
end, { desc = "Open location list with buffer diagnostics" })
--
--
-- Window resize (like tmux resize-pane), direction flips at screen edges.
-- After first <leader>+dir, plain h/j/k/l repeat resize for 1.5s without leader.
local resize_timer = nil

local resize_fns = {
	j = function()
		local at_bottom = vim.fn.winnr("j") == vim.fn.winnr()
		vim.cmd(string.format("resize %+d", at_bottom and -5 or 5))
	end,
	k = function()
		local at_bottom = vim.fn.winnr("j") == vim.fn.winnr()
		vim.cmd(string.format("resize %+d", at_bottom and 5 or -5))
	end,
	l = function()
		local at_left = vim.fn.winnr("h") == vim.fn.winnr()
		vim.cmd(string.format("vertical resize %+d", at_left and 5 or -5))
	end,
	h = function()
		local at_left = vim.fn.winnr("h") == vim.fn.winnr()
		vim.cmd(string.format("vertical resize %+d", at_left and -5 or 5))
	end,
}

local function deactivate_resize_mode()
	if resize_timer then
		resize_timer:stop()
		resize_timer:close()
		resize_timer = nil
	end
	for dir in pairs(resize_fns) do
		pcall(vim.keymap.del, "n", dir)
	end
end

local function activate_resize_mode()
	if resize_timer then
		resize_timer:stop()
		resize_timer:close()
	end
	for dir, fn in pairs(resize_fns) do
		vim.keymap.set("n", dir, function()
			fn()
			activate_resize_mode()
		end, { nowait = true })
	end
	resize_timer = vim.uv.new_timer()
	resize_timer:start(1500, 0, vim.schedule_wrap(deactivate_resize_mode))
end

for dir, fn in pairs(resize_fns) do
	vim.keymap.set("n", "<leader>" .. dir, function()
		fn()
		activate_resize_mode()
	end, { desc = "Resize window " .. dir })
end

-- Maximize current window (toggle), tracked at tab level so switching windows doesn't break it
vim.keymap.set("n", "<leader>m", function()
	if vim.fn.winnr("$") == 1 then return end
	if vim.t._maximized_win then
		vim.cmd("wincmd =")
		vim.t._maximized_win = nil
	else
		vim.cmd("wincmd |")
		vim.cmd("wincmd _")
		vim.t._maximized_win = vim.api.nvim_get_current_win()
	end
end, { desc = "Toggle maximize window" })

-- Open dbee scratchpad
vim.keymap.set("n", "<leader>db", function()
	require("dbee").open()
end, { desc = "Open dbee scratchpad" })

vim.keymap.set("n", "<leader>dr", function()
	require("dbee").execute(vim.fn.expand("%")) -- run current file
end, { desc = "DBee run file" })

vim.keymap.set("v", "<leader>dr", function()
	-- get visual selection and execute it
	local start = vim.fn.getpos("'<")
	local finish = vim.fn.getpos("'>")
	local lines = vim.api.nvim_buf_get_lines(0, start[2] - 1, finish[2], false)
	require("dbee").execute(table.concat(lines, "\n"))
end, { desc = "DBee run selection" })

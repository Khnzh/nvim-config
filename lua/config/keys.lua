-- CENTERING WHEN JUMPING TO OCCURENCES
vim.api.nvim_set_keymap("n", "n", "nzz", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "N", "Nzz", { noremap = true, silent = true })
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

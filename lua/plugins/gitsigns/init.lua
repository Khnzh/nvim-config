return {
	"lewis6991/gitsigns.nvim",
	config = function()
		require("gitsigns").setup({
			current_line_blame = true, -- the GitLens-like inline blame
			current_line_blame_opts = {
				delay = 300,
				virt_text_pos = "eol", -- end of line
			},
			current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
		})

		-- Optional keymaps
		vim.keymap.set("n", "<leader>gb", ":Gitsigns blame_line<CR>")
		vim.keymap.set("n", "<leader>gd", ":Gitsigns diffthis<CR>")
		vim.keymap.set("n", "<leader>gp", ":Gitsigns preview_hunk<CR>")
	end,
}

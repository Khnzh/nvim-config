require("buffer-picker").setup({
	height = 20,
	width = 60,
	border = "single",
	show_file_icons = true, -- Requires nvim-web-devicons
	highlight_selected = true,
	selected_highlight = "Tag",
	mappings = {
		close = { "q", "<Esc>" },
		select = "<CR>",
		delete = "dd",
		next_buffer = "<Down>",
		prev_buffer = "<Up>",
	},
})

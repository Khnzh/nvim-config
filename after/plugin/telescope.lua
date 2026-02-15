local builtin = require("telescope.builtin")
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local utils = require("telescope.utils")

vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
vim.keymap.set("n", "<C-p>", builtin.git_files, { desc = "Telescope git find files" })
vim.keymap.set("n", "<leader>ps", function()
	builtin.grep_string({ search = vim.fn.input("Grep > ") })
end, { desc = "Telescope find files" })

-- TO OPEN MULTIPLE FILES
-- WHEN NEEDED
local function append_to_bufferlist(prompt_bufnr)
	local picker = action_state.get_current_picker(prompt_bufnr)
	local selections = picker:get_multi_selection()

	local function add_entry(entry)
		if not entry then
			return
		end

		-- Try to get the absolute path
		local filepath

		-- Method 1: Use entry.path if available
		if entry.path then
			filepath = entry.path
		-- Method 2: Use entry.filename if available
		elseif entry.filename then
			filepath = entry.filename
		-- Method 3: Parse from entry.value for grep results
		elseif entry.value then
			-- Extract just the filename part (remove :line:col:text)
			local match = entry.value:match("^([^:]+)")
			if match then
				-- Get the picker's cwd and make it absolute
				local cwd = picker.cwd or vim.fn.getcwd()
				filepath = vim.fn.fnamemodify(cwd .. "/" .. match, ":p")
			end
		end

		if filepath and vim.fn.filereadable(filepath) == 1 then
			vim.cmd("badd " .. vim.fn.fnameescape(filepath))
			return true
		end
		return false
	end

	if #selections > 0 then
		local added = 0
		for _, entry in ipairs(selections) do
			if add_entry(entry) then
				added = added + 1
			end
		end
		if added > 0 then
			vim.notify(string.format("Added %d files to buffers", added), vim.log.levels.INFO)
		end
	else
		local entry = action_state.get_selected_entry()
		if entry and add_entry(entry) then
			vim.notify("Added to buffers", vim.log.levels.INFO)
		end
	end

	return true
end

-- ACTS BASED ON DISPLAY
-- HORIZONTAL OR VERTICAL
local function get_telescope_layout()
	local width = vim.o.columns

	if width < 110 then -- Portrait mode
		return {
			strategy = "vertical",
			config = {
				vertical = {
					preview_height = 0.4,
					width = 0.95,
					height = 0.9,
					prompt_position = "bottom",
				},
				preview_cutoff = 10,
			},
		}
	else -- Landscape mode
		return {
			strategy = "horizontal",
			config = {
				horizontal = {
					preview_width = 0.55,
					results_width = 0.8,
					prompt_position = "bottom",
				},
				width = 0.87,
				height = 0.80,
				preview_cutoff = 120,
			},
		}
	end
end

local layout = get_telescope_layout()

require("telescope").setup({
	defaults = {
		prompt_prefix = "   ",
		initial_mode = "insert",
		selection_strategy = "reset",
		sorting_strategy = "ascending",
		layout_strategy = layout.strategy,
		layout_config = layout.config,
		path_display = { "truncate" },
		keys = {
			{
				"<leader>fa",
				"<cmd>Telescope find_files follow=true no_ignore=true hidden=true<CR>",
				desc = "Find All Files (including hidden)",
			},
		},
		mappings = {
			i = {
				["<Tab>"] = actions.toggle_selection,
				["<C-a>"] = append_to_bufferlist,
			},
			n = {
				["<Tab>"] = actions.toggle_selection,
				["<C-s>"] = append_to_bufferlist,
			},
		},
	},

	pickers = {
		live_grep = {
			-- Специфичные настройки для live_grep
			previewer = true,
		},
	},
})

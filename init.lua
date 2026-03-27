require("config.lazy")
require("config.opts")
require("config.keys")
require("config.lsp")
-- Incrementing logger.error function
local logger_counter = 0

vim.api.nvim_create_user_command("LoggerError", function()
	logger_counter = logger_counter + 1
	local line = string.format('logger.error("logger %d")', logger_counter)
	vim.fn.setreg("+", line)
	vim.api.nvim_put({ line }, "l", true, true)
end, {})

-- Map <leader>de to the command
vim.api.nvim_set_keymap("n", "<leader>de", ":LoggerError<CR>", { noremap = true, silent = true })

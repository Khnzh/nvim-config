vim.lsp.enable("ts_ls")

vim.lsp.enable("lua_ls")

vim.lsp.enable("golangci_lint_ls")

vim.lsp.enable("gopls")

vim.lsp.enable("pylsp")

vim.lsp.config("yamlls", {
	settings = {
		yaml = {
			schemas = {
				["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "docker-compose*.yml",
			},
			validate = true,
			completion = true,
			hover = true,
		},
	},
})
vim.lsp.enable("yamlls")

vim.lsp.config("sqls", {
	handlers = {
		["window/showMessage"] = function(_, result, ctx)
			if result.message and result.message:match("no database connection") then
				return
			end
			vim.lsp.handlers["window/showMessage"](nil, result, ctx)
		end,
	},
	settings = {
		sqls = {
			connections = {
				{
					driver = "postgresql",
					dataSourceName = string.format(
						"host=%s port=%s user=%s password=%s dbname=%s sslmode=disable",
						os.getenv("AXI4UTF_HOST") or "",
						os.getenv("AXI4UTF_PORT") or "",
						os.getenv("AXI4UTF_USER") or "",
						os.getenv("AXI4UTF_PASSWORD") or "",
						os.getenv("AXI4UTF_DB") or ""
					),
				},
			},
		},
	},
})
vim.lsp.enable("sqls")

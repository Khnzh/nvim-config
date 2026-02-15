vim.lsp.enable("ts_ls")

vim.lsp.enable("lua_ls")

vim.lsp.enable("golangci_lint_ls")

vim.lsp.enable("gopls")

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

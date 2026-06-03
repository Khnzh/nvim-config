return {
	"williamboman/mason.nvim",
	build = ":MasonUpdate",
	config = function()
		require("mason").setup()
		local registry = require("mason-registry")
		local tools = {
			"stylua",
			"isort",
			"black",
			"prettierd",
			"prettier",
			"goimports",
			"pgformatter",
		}
		registry.refresh(function()
			for _, name in ipairs(tools) do
				local ok, pkg = pcall(registry.get_package, name)
				if ok and not pkg:is_installed() then
					pkg:install()
				end
			end
		end)
	end,
}

return {
	"kndndrj/nvim-dbee",
	dependencies = {
		"MunifTanjim/nui.nvim",
	},
	build = function()
		-- Install tries to automatically detect the install method.
		-- if it fails, try calling it with one of these parameters:
		--    "curl", "wget", "bitsadmin", "go"
		require("dbee").install()
	end,
	config = function()
		local mem = {}
		for _, conn in ipairs(require("config.db")) do
			table.insert(mem, { name = conn.name, type = conn.type, url = conn.url })
		end
		require("dbee").setup({
			sources = {
				require("dbee.sources").MemorySource:new(mem),
				require("dbee.sources").EnvSource:new("DBEE_CONNECTIONS"),
				require("dbee.sources").FileSource:new(vim.fn.stdpath("cache") .. "/dbee/persistence.json"),
			},
		})
	end,
}

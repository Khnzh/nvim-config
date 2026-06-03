return {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
        ensure_installed = {
            "lua_ls",
            "ts_ls",
            "golangci_lint_ls",
            "gopls",
            "pylsp",
            "yamlls",
            "sqls",
        },
    },
}

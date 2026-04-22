local capabilities = require("cmp_nvim_lsp").default_capabilities()

require("mason").setup({
	ui = {
		icons = {
			package_installed = "✓",
			package_pending = "➜",
			package_uninstalled = "✗",
		},
	},
})

require("mason-lspconfig").setup({
	ensure_installed = {
		-- "lua_ls"
	},
	automatic_installation = true,
})

vim.lsp.config("vtsls", {
	capabilities = capabilities,
})
vim.lsp.enable("vtsls")

vim.lsp.config("cssls", {
	capabilities = capabilities,
})
vim.lsp.enable("cssls")

vim.lsp.config("vuels", {
	capabilities = capabilities,
})
vim.lsp.enable("vuels")

vim.lsp.config("html", {
	capabilities = capabilities,
})
vim.lsp.enable("html")

vim.lsp.config("clangd", {
	cmd = { "clangd-18" },
	filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
	root_markers = { "compile_commands.json", ".git" },
	capabilities = vim.tbl_deep_extend("force", {}, capabilities, {
		offsetEncoding = { "utf-8", "utf-16" },
		textDocument = {
			completion = {
				editsNearCursor = true,
			},
		},
	}),
})
vim.lsp.enable("clangd")

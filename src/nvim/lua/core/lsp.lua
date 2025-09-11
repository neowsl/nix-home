local servers = {
	"astro",
	"bashls",
	"clangd",
	"cssls",
	"emmet_language_server",
	"gdscript",
	"gopls",
	"html",
	-- "lexical",
	"lua_ls",
	"nil_ls",
	-- "ocamllsp",
	"pyrefly",
	"svelte",
	"tailwindcss",
	"tinymist",
	"ts_ls",
	-- "verible",
	"yamlls",
}

vim.lsp.config("html", {
	filetypes = { "html", "elixir", "heex" },
})

vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			completion = { callSnippet = "Replace" },
			diagnostics = {
				disable = { "missing-fields" },
			},
			workspace = { checkThirdParty = false },
		},
	},
})

vim.lsp.config("tailwindcss", {
	settings = {
		tailwindCSS = {
			includeLanguages = {
				elixir = "html-eex",
				heex = "html-eex",
			},
		},
	},
})

vim.lsp.enable(servers)

vim.diagnostic.config {
	virtual_text = false,
	virtual_lines = {
		only_current_line = true,
	},
}

vim.fn.sign_define(
	"DiagnosticSignError",
	{ text = "●", texthl = "DiagnosticSignError" }
)
vim.fn.sign_define(
	"DiagnosticSignWarn",
	{ text = "●", texthl = "DiagnosticSignWarn" }
)
vim.fn.sign_define(
	"DiagnosticSignInfo",
	{ text = "●", texthl = "DiagnosticSignInfo" }
)
vim.fn.sign_define(
	"DiagnosticSignHint",
	{ text = "●", texthl = "DiagnosticSignHint" }
)

local servers = {
	"astro",
	"bashls",
	"clangd",
	"cssls",
	"emmet_language_server",
	"gdscript",
	"gopls",
	"hls",
	"html",
	"jdtls",
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

vim.lsp.config("hls", {
	settings = {
		haskell = {
			plugin = {
				hlint = { globalOn = false },
			},
		},
	},
})

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
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "●",
			[vim.diagnostic.severity.WARN] = "●",
			[vim.diagnostic.severity.INFO] = "●",
			[vim.diagnostic.severity.HINT] = "●",
		},
		linehl = {
			[vim.diagnostic.severity.ERROR] = "ErrorMsg",
		},
		numhl = {
			[vim.diagnostic.severity.WARN] = "WarningMsg",
		},
	},
}

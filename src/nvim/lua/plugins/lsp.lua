return {
	{
		"neovim/nvim-lspconfig",
	},
	{
		"mason-org/mason-lspconfig.nvim",
		dependencies = {
			{ "mason-org/mason.nvim", opts = {} },
			"neovim/nvim-lspconfig",
		},
		opts = {
			ensure_installed = {
				"mdx_analyzer",
			},
		},
	},
	{
		"nvimdev/lspsaga.nvim",
		event = "LspAttach",
		opts = {
			code_action = {
				keys = { quit = "<Esc>" },
			},
			finder = {
				keys = {
					quit = "<Esc>",
					toggle_or_open = "<CR>",
				},
			},
			lightbulb = { enable = false },
			rename = {
				keys = { quit = "<Esc>" },
			},
		},
		keys = {
			{ "<Leader>h", ":Lspsaga hover_doc<CR>", silent = true },
			{ "<Leader>a", ":Lspsaga code_action<CR>", silent = true },
			{ "<Leader>r", ":Lspsaga rename<CR>", silent = true },
			{ "<Leader>f", ":Lspsaga finder<CR>", silent = true },
		},
	},
	{
		"ray-x/lsp_signature.nvim",
		opts = {
			bind = true,
			handler_opts = {
				border = "rounded",
			},
		},
	},
	{
		"https://git.sr.ht/~whynothugo/lsp_lines.nvim",
		opts = {},
	},
}

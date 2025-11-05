-- language-specific plugins
return {
	{
		"chomosuke/typst-preview.nvim",
		ft = "typst",
		opts = {
			dependencies_bin = {
				["tinymist"] = "tinymist",
				["websocat"] = "websocat",
			},
		},
		keys = {
			-- {
			-- 	"<Leader>e",
			-- 	function()
			-- 		vim.fn.jobstart(
			-- 			{ "xdg-open", vim.fn.expand "%:p:r" .. ".pdf" },
			-- 			{ detach = true }
			-- 		)
			-- 	end,
			-- 	buffer = true,
			-- },
			{
				"<Leader>e",
				":TypstPreviewToggle<CR>",
			},
		},
	},
	{
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {},
	},
	{
		"mrcjkb/haskell-tools.nvim",
		ft = "haskell",
	},
	{
		"mrcjkb/rustaceanvim",
		lazy = false,
	},
	{
		"nvim-flutter/flutter-tools.nvim",
		lazy = false,
		dependencies = {
			"nvim-lua/plenary.nvim",
			"stevearc/dressing.nvim",
		},
		config = true,
	},
}

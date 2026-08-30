return {
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter").install {
				"arduino",
				"astro",
				"bash",
				"c",
				"clojure",
				"cpp",
				"css",
				"elixir",
				"gdscript",
				"gleam",
				"go",
				"haskell",
				"heex",
				"html",
				"hyprlang",
				"java",
				"javascript",
				"json",
				"lua",
				"make",
				"markdown",
				"markdown_inline",
				"nix",
				-- "ocaml",
				"python",
				"rust",
				"sql",
				"svelte",
				"tcl",
				"tsx",
				"typescript",
				"typst",
				"yaml",
				"zig",
			}

			vim.api.nvim_create_autocmd("FileType", {
				pattern = "*",
				callback = function(args)
					pcall(vim.treesitter.start, args.buf)
				end,
			})
		end,
	},
}

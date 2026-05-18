-- tooling plugins
return {
	-- formatting
	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = {
				astro = { "biome-check" },
				css = { "biome-check" },
				elixir = { "mix" },
				gdscript = { "gdformat" },
				go = { "gofmt" },
				haskell = { "ormolu" },
				heex = { "mix" },
				html = { "biome-check" },
				-- java = { "google-java-format" },
				java = { "biome-check" },
				javascript = { "biome-check" },
				javascriptreact = { "biome-check" },
				json = { "biome-check" },
				jsonc = { "biome-check" },
				lua = { "stylua" },
				mdx = { "biome-check" },
				nix = { "nixfmt" },
				-- ocaml = { "ocamlformat" },
				python = { "isort", "black" },
				rust = { "rustfmt" },
				scss = { "biome-check" },
				svelte = { "biome-check" },
				typescript = { "biome-check" },
				typescriptreact = { "biome-check" },
				typst = { "typstyle" },
				verilog = { "verible" },
				yaml = { "biome-check" },
			},
			format_after_save = {
				lsp_fallback = true,
				quiet = true,
			},
			formatters = {
				gdformat = {
					command = "gdformat",
					args = "$FILENAME",
					stdin = false,
				},
				["google-java-format"] = {
					prepend_args = { "--aosp" },
				},
				verible = {
					command = "verible-verilog-format",
					prepend_args = { "--indentation_spaces", "4" },
				},
			},
		},
	},
	-- linting
	{
		"mfussenegger/nvim-lint",
		config = function()
			local lint = require "lint"

			lint.linters_by_ft = {
				astro = { "biomejs" },
				haskell = { "hlint" },
				javascript = { "biomejs" },
				svelte = { "biomejs" },
				typescript = { "biomejs" },
			}

			vim.api.nvim_create_autocmd({ "BufWritePost" }, {
				callback = function()
					lint.try_lint()
				end,
			})
		end,
	},
}

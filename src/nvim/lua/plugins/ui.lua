return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		config = function()
			require("catppuccin").setup {
				transparent_background = true,
				custom_highlights = function(colours)
					return {
						NormalFloat = { bg = colours.none },
						FloatBorder = {
							fg = colours.lavender,
							bg = colours.none,
						},
						FloatTitle = {
							fg = colours.blue,
							bg = colours.none,
						},
						FloatFooter = {
							fg = colours.blue,
							bg = colours.none,
						},
					}
				end,
			}

			vim.g.catppuccin_flavour = "mocha"
			vim.cmd.colorscheme "catppuccin"
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = {
			"catppuccin/nvim",
		},
		opts = {
			options = {
				theme = "catppuccin",
				component_separators = "|",
				section_separators = { left = "", right = "" },
			},
			sections = {
				lualine_a = {
					{
						"mode",
						separator = { left = "" },
						right_padding = 2,
					},
				},
				lualine_b = {
					"filename",
					"branch",
					{ "diff", colored = false },
				},
				lualine_c = {},
				lualine_x = {},
				lualine_y = { "filetype", "progress" },
				lualine_z = {
					{
						"location",
						separator = { right = "" },
						left_padding = 2,
					},
				},
			},
			inactive_sections = {
				lualine_a = { "filename" },
				lualine_b = {},
				lualine_c = {},
				lualine_x = {},
				lualine_y = {},
				lualine_z = {},
			},
		},
	},
	-- NOTE: trying out dev experience without bufferline
	-- {
	-- 	"akinsho/bufferline.nvim",
	-- 	dependencies = {
	-- 		"catppuccin/nvim",
	-- 	},
	-- 	config = function()
	-- 		require("bufferline").setup {
	-- 			options = {
	-- 				diagnostics = "nvim_lsp",
	-- 				diagnostics_indicator = function(count, level, _, _)
	-- 					local icon = level:match "error" and " " or " "
	-- 					return " " .. icon .. count
	-- 				end,
	-- 				separator_style = "slant",
	-- 			},
	-- 			-- https://github.com/catppuccin/nvim?tab=readme-ov-file#integrations
	-- 			highlights = require(
	-- 				"catppuccin.groups.integrations.bufferline"
	-- 			).get(),
	-- 		}

	-- 		vim.keymap.set(
	-- 			"n",
	-- 			"<Leader>`",
	-- 			":BufferLineTogglePin<CR>",
	-- 			{ silent = true }
	-- 		)
	-- 	end,
	-- },
	{
		"DaikyXendo/nvim-material-icon",
		opts = {
			override_by_extension = {
				["gleam"] = {
					icon = "",
					color = "#ffaff3",
					name = "Gleam",
				},
			},
		},
	},
	{
		"gelguy/wilder.nvim",
		dependencies = {
			"DaikyXendo/nvim-material-icon",
		},
		opts = {
			modes = { ":", "/", "?" },
		},
		config = function(_, opts)
			local wilder = require "wilder"

			wilder.setup(opts)

			wilder.set_option(
				"renderer",
				wilder.popupmenu_renderer(wilder.popupmenu_border_theme {
					highlighter = wilder.basic_highlighter(),
					highlights = {
						accent = "FloatBorder",
						border = "FloatBorder",
					},
					left = { " ", wilder.popupmenu_devicons() },
					right = { " ", wilder.popupmenu_scrollbar() },
					border = "rounded",
				})
			)

			-- https://github.com/nvim-telescope/telescope.nvim/issues/3436#issuecomment-2756267300
			vim.api.nvim_create_autocmd("CmdlineEnter", {
				callback = function()
					vim.opt_local.winborder = "none"
					vim.api.nvim_create_autocmd("CmdlineLeave", {
						once = true,
						callback = function()
							vim.opt_local.winborder = "rounded"
						end,
					})
				end,
			})
		end,
	},
	{
		"j-hui/fidget.nvim",
		opts = {
			-- https://github.com/catppuccin/nvim?tab=readme-ov-file#integrations
			notification = { window = { winblend = 0 } },
		},
	},
}

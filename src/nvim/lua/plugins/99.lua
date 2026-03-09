return {
	{
		"ThePrimeagen/99",
		config = function()
			local _99 = require "99"

			_99.setup {
				model = "opencode/minimax-m2.5-free",
			}

			vim.keymap.set("v", "<Leader>9", function()
				_99.visual {}
			end)
		end,
	},
}

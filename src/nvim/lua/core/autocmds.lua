local lang_maps = {
	arduino = {
		build = "arduino-cli compile --fqbn arduino:avr:uno %",
		exec = "arduino-cli upload -p /dev/ttyACM0 --fqbn arduino:avr:uno %",
	},
	c = { build = "gcc *.c -lm -g -o main", exec = "./main" },
	clojure = { exec = "lein run" },
	cpp = {
		build = "mkdir -p build && cd build && cmake .. && make",
		exec = "cd build && ./main",
	},
	elixir = { exec = "mix run" },
	gleam = { exec = "gleam run" },
	go = { build = "go build", exec = "go run %" },
	haskell = { exec = "cabal run" },
	java = { build = "javac %", exec = "java %:r" },
	javascript = { exec = "bun %" },
	python = { exec = "python %" },
	rust = { exec = "cargo run" },
	sh = { exec = "%" },
	tex = { build = "pdflatex -shell-escape %" },
	typescript = { exec = "bun %" },
}

for lang, data in pairs(lang_maps) do
	local f, _ = io.open("Makefile", "r")
	if f then
		data.build = "make build"
		data.exec = "make exec"
	end

	if data.build ~= nil then
		vim.api.nvim_create_autocmd("FileType", {
			pattern = lang,
			command = "nnoremap <Leader>b :!" .. data.build .. "<CR>",
		})
	end

	if data.exec ~= nil then
		vim.api.nvim_create_autocmd("FileType", {
			pattern = lang,
			command = "nnoremap <Leader>e :split<CR>:terminal "
				.. data.exec
				.. "<CR>",
		})
	end
end

vim.api.nvim_create_autocmd(
	"InsertEnter",
	{ command = "set norelativenumber", pattern = "*" }
)
vim.api.nvim_create_autocmd(
	"InsertLeave",
	{ command = "set relativenumber", pattern = "*" }
)

vim.filetype.add {
	extension = {
		astro = "astro",
		tpp = "cpp",
		mdx = "markdown.mdx",
	},
	pattern = {
		["hyprland.conf"] = "hyprlang",
	},
}

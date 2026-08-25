local bufnr = vim.api.nvim_get_current_buf()

vim.api.nvim_create_autocmd("BufWritePre", {
	buffer = bufnr,
	callback = function()
		local client = vim.lsp.get_clients({ bufnr = bufnr, name = "zls" })[1]
		if not client then
			return
		end

		local range_params =
			vim.lsp.util.make_range_params(0, client.offset_encoding)
		local params = {
			textDocument = range_params.textDocument,
			range = range_params.range,
			context = {
				only = { "source.organizeImports" },
				diagnostics = {},
			},
		}

		local responses = vim.lsp.buf_request_sync(
			bufnr,
			"textDocument/codeAction",
			params,
			1000
		)
		for client_id, response in pairs(responses or {}) do
			for _, action in ipairs(response.result or {}) do
				local response_client = vim.lsp.get_client_by_id(client_id)
				if action.edit and response_client then
					vim.lsp.util.apply_workspace_edit(
						action.edit,
						response_client.offset_encoding
					)
				end
			end
		end
	end,
})

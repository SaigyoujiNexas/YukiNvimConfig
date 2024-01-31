return {
	{
		"simrat39/rust-tools.nvim",
		lazy = true,
		opts = function()
			local mason_registry = require("mason-registry")
			local adapter
			local codelldb = mason_registry.get_package("codelldb")
			local extension_path = codelldb:get_install_path() .. "/extension/"
			local codelldb_path = extension_path .. "adapter/codelldb"
			local liblldb_path = ""
			liblldb_path = extension_path .. "lldb/lib/liblldb.so"
			adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path)
			return {
				dap = {
					adapter = adapter,
				},
				tools = {
					on_initialized = function()
						vim.cmd([[
                augroup RustLSP
                  autocmd CursorHold                      *.rs silent! lua vim.lsp.buf.document_highlight()
                  autocmd CursorMoved,InsertEnter         *.rs silent! lua vim.lsp.buf.clear_references()
                  autocmd BufEnter,CursorHold,InsertLeave *.rs silent! lua vim.lsp.codelens.refresh()
                augroup END
              ]])
					end,
				},
			}
		end,
		config = function() end,
	},
    {
        "rouge8/neotest-rust"
    }
}

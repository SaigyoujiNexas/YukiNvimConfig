return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{
				"folke/neoconf.nvim",
				cmd = "Neoconf",
				config = false,
				dependencies = { "nvim-lspconfig" },
			},
			{
				"folke/neodev.nvim",
				opts = {},
			},
			"mason.nvim",
			"williamboman/mason-lspconfig.nvim",
		},
		opts = {
			diagnostics = {
				underline = true,
				update_in_insert = false,
				virtual_text = {
					spacing = 4,
					source = "if_many",
					prefix = "",
				},
				severity_sort = true,
			},
			inlay_hints = {
				enabled = false,
			},
			capabilities = {},
			format = {
				formatting_options = nil,
				timeout_ms = nil,
			},
			servers = {
				lua_ls = {
					settings = {
						Lua = {
							workspace = {
								checkThirdParty = false,
							},
							completion = {
								callSnippet = "Replace",
							},
						},
					},
				},
				rust_analyzer = {
					settings = {
						["rust-analyzer"] = {
							cargo = {
								allFeatures = true,
								loadOutDirsFromCheck = true,
								runBuildScripts = true,
							},
							checkOnSave = {
								allFeatures = true,
								command = "clippy",
								extraArgs = { "--no-deps" },
							},
							procMacro = {
								enable = true,
								ignored = {
									["async-trait"] = { "async_trait" },
									["napi-derive"] = { "napi" },
									["async-recursion"] = { "async_recursion" },
								},
							},
						},
					},
				},
				clangd = {
					root_dir = function(fname)
						return require("lspconfig.util").root_pattern(
							"Makefile",
							"configure.ac",
							"configure.in",
							"config.h.in",
							"meson.build",
							"meson_options.txt",
							"build.ninja"
						)(fname) or require("lspconfig.util").root_pattern(
							"compile_commands.json",
							"compile_flags.txt"
						)(fname) or require("lspconfig.util").find_git_ancestor(fname)
					end,
					capabilities = {
						offsetEncoding = { "utf-16" },
					},
					cmd = {
						"clangd",
						"--background-index",
						"--clang-tidy",
						"--header-insertion=iwyu",
						"--completion-style=detailed",
						"--function-arg-placeholders",
						"--fallback-style=llvm",
					},
					init_options = {
						usePlaceholders = true,
						completeUnimported = true,
						clangdFileStatus = true,
					},
				},
				taplo = {
					keys = {
						{
							"K",
							function()
								if vim.fn.expand("%:t") == "Cargo.toml" and require("crates").popup_available() then
									require("crates").show_popup()
								else
									vim.lsp.buf.hover()
								end
							end,
							desc = "Show Crate Documentation",
						},
					},
				},
				jdtls = {},
				omnisharp = {
					handlers = {
						["textDocument/definition"] = function(...)
							return require("omnisharp_extended").handler(...)
						end,
					},
					keys = {
						{
							"gd",
							function()
								require("omnisharp_extended").telescope_lsp_definitions()
							end,
							desc = "Goto Definition",
						},
					},
					enable_roslyn_analyzers = true,
					organize_imports_on_format = true,
					enable_import_completion = true,
				},
			},
			setup = {
				rust_analyzer = function(_, opts)
					require("rust-tools").setup(vim.tbl_deep_extend("force", {}, { server = opts }))
					return true
				end,
				clangd = function(_, opts)
					require("clangd_extensions").setup(vim.tbl_deep_extend("force", {}, { server = opts }))
					return false
				end,
				jdtls = function()
					return true
				end,
			},
		},
		config = function(_, opts)
			if opts.autoformat ~= nil then
				vim.g.autoformat = opts.autoformat
			end
			local register_capability = vim.lsp.handlers["client/registerCapability"]
			vim.lsp.handlers["client/registerCapability"] = function(err, res, ctx)
				local ret = register_capability(err, res, ctx)
				return ret
			end

			vim.diagnostic.config(vim.deepcopy(opts.diagnostics))
			local servers = opts.servers
			local cmp_nvim_lsp = require("cmp_nvim_lsp")
			local capabilities = vim.tbl_deep_extend(
				"force",
				{},
				vim.lsp.protocol.make_client_capabilities(),
				cmp_nvim_lsp.default_capabilities(),
				opts.capabilities or {}
			)
			local function setup(server)
				local server_opts = vim.tbl_deep_extend("force", {
					capabilities = vim.deepcopy(capabilities),
				}, servers[server] or {})
				if opts.setup[server] then
					if opts.setup[server](server, server_opts) then
						return
					end
				elseif opts.setup["*"] then
					if opts.setup["*"](server, server_opts) then
						return
					end
				end
				require("lspconfig")[server].setup(server_opts)
			end
			local mlsp = require("mason-lspconfig")
			local all_mslp_servers = vim.tbl_keys(require("mason-lspconfig.mappings.server").lspconfig_to_package)
			local ensure_installed = {}
			for server, server_opts in pairs(servers) do
				if server_opts then
					server_opts = server_opts == true and {} or server_opts
					if server_opts.mason == false or vim.tbl_contains(all_mslp_servers, server) then
						setup(server)
					else
						ensure_installed[#ensure_installed + 1] = server
					end
				end
			end
			mlsp.setup({ ensure_installed = ensure_installed, handlers = { setup } })
			local k = vim.keymap
			-- k.set("n", "gpg", vim.diagnostic.goto_prev)
			-- k.set("n", "gng", vim.diagnostic.goto_next)
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = function(ev)
					-- Enable completion triggered by <c-x><c-o>
					vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
					local opt = { buffer = ev.buf }
					k.set("n", "gd", vim.lsp.buf.definition, opt)
					k.set("n", "gt", vim.lsp.buf.type_definition, opt)
					k.set("n", "gi", vim.lsp.buf.implementation, opt)
					k.set("n", "gr", vim.lsp.buf.references, opt)
					--show documents
					k.set("n", "sd", vim.lsp.buf.hover, opt)
					k.set("n", "rn", vim.lsp.buf.rename, opt)
					-- format code by <leader>f in xmap and nmap
					-- k.set("n", "<leader>f", vim.lsp.buf.format, opt)
					-- k.set("x", "<leader>f", vim.lsp.buf.format, opt)
					k.set("n", "<leader>a", vim.lsp.buf.code_action, opt)
					k.set("x", "<leader>a", vim.lsp.buf.code_action, opt)
					k.set("n", "<leader>ac", vim.lsp.buf.code_action, opt)
					k.set("n", "<leader>as", vim.lsp.buf.code_action, opt)
					--quick fix
					--remap keys for applying refactor code actions.
					k.set("n", "<leader>re", function()
						vim.lsp.buf.code_action({ only = { "refactor" } })
					end, opt)
					k.set("x", "<leader>r", function()
						vim.lsp.buf.code_action({ only = { "refactor" } })
					end, opt)
					k.set("n", "<leader>r", function()
						vim.lsp.buf.code_action({ only = { "refactor" } })
					end, opt)
					--code len actions
					k.set("n", "<leader>cl", vim.lsp.codelens.run, opt)
					-- use ctrl-s for selection ranges
					k.set("n", "<leader>qf", function()
						vim.lsp.buf.code_action({
							only = { "quickfix" },
						})
					end, opt)
				end,
			})
		end,
	},
}

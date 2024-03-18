local Util = require("util")
local M = {}

---@param opts ConformOpts
function M.setup(_, opts)
	for name, formatter in pairs(opts.formatters or {}) do
		if type(formatter) == "table" then
			---@diagnostic disable-next-line: undefined-field
			if formatter.extra_args then
				---@diagnostic disable-next-line: undefined-field
				formatter.prepend_args = formatter.extra_args
				Util.deprecate(
					("opts.formatters.%s.extra_args"):format(name),
					("opts.formatters.%s.prepend_args"):format(name)
				)
			end
		end
	end

	for _, key in ipairs({ "format_on_save", "format_after_save" }) do
		if opts[key] then
			Util.warn(
				("Don't set `opts.%s` for `conform.nvim`.\n**LazyVim** will use the conform formatter automatically"):format(
					key
				)
			)
			---@diagnostic disable-next-line: no-unknown
			opts[key] = nil
		end
	end
	require("conform").setup(opts)
end

return {
	"stevearc/conform.nvim",
	dependencies = { "mason.nvim" },
	lazy = true,
	cmd = "ConformInfo",
	keys = {
		{
			"<leader>f",
			function()
				require("conform").format()
			end,
			mode = { "n", "v" },
			desc = "Format Injected Langs",
		},
	},
	init = function()
		require("util").on_very_lazy(function()
			require("util").format.register({
				name = "conform.nvim",
				priority = 100,
				primary = true,
				format = function(buf)
					local plugin = require("lazy.core.config").plugins["conform.nvim"]
					local Plugin = require("lazy.core.plugin")
					local opts = Plugin.values(plugin, "opts", false)
					require("conform").format(Util.merge(opts.format, { bufnr = buf }))
				end,
				sources = function(buf)
					local ret = require("conform").list_formatters(buf)
					---@param v conform.FormatterInfo
					return vim.tbl_map(function(v)
						return v.name
					end, ret)
				end,
			})
		end)
	end,
	opts = function()
		local plugin = require("lazy.core.config").plugins["conform.nvim"]
		if plugin.config ~= M.setup then
			Util.error({
				"Don't set `plugin.config` for `conform.nvim`.\n",
			}, { title = "LazyVim" })
		end
		local opts = {
			format = {
				timeout_ms = 3000,
				async = false,
				quiet = false,
				lsp_fallback = true,
			},
			formatters_by_ft = {
				lua = { "stylua" },
				fish = { "fish_indent" },
				sh = { "shfmt" },
				cs = { "csharpier" },
			},
			formatters = {
				csharpier = {
					command = "dotnet-csharpier",
					args = { "--write-stdout" },
				},
				injected = { options = { ignore_errors = true } },
			},
		}
		return opts
	end,
	config = M.setup,
}

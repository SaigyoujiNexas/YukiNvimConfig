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
	opts = function()
		local opts = {
			format = {
				timeout_ms = 3000,
				async = false,
				quiet = false,
			},
			formatters_by_ft = {
				lua = { "stylua" },
				fish = { "fish_indent" },
				sh = { "shfmt" },
			},
			formatters = {
				injected = { options = { ignore_errors = true } },
			},
		}
		return opts
	end,
}

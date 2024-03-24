return {
	"catppuccin/nvim",
	name = "catppuccin",
	lazy = true,
	opts = {
		integrations = {
			aerial = true,
			alpha = true,
			cmp = true,
			dashboard = true,
			flash = true,
			gitsigns = true,
			headlines = true,
			illuminate = true,
			indent_blankline = {
				enabled = true,
			},
			leap = true,
			lsp_trouble = true,
			mason = true,
			markdown = true,
			mini = {
				enabled = true,
			},
			native_lsp = {
				enabled = true,
				underlines = {
					errors = { "undercurl" },
					hints = { "undercurl" },
					warnings = { "undercurl" },
					information = { "undercurl" },
				},
			},
			navic = { enabled = true, custom_bg = "lualine" },
			neotest = true,
			neotree = true,
			noice = true,
			notify = true,
			semantic_tokens = true,
			rainbow_delimiters = true,
			telescope = true,
			treesitter = true,
			treesitter_context = true,
			which_key = true,
		},
		flavour = "macchiato",
		transparent_background = true,
	},
	config = function(_, opts)
		require("catppuccin").setup(opts)
		vim.cmd.colorscheme("catppuccin")
	end,
}

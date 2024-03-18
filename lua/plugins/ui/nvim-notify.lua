local Util = require("util")
return {
	"rcarriga/nvim-notify",
	opts = {
		background_colour = "#000000",
		timeout = 3000,
		icons = {
			ERROR = "",
			WARN = "",
			INFO = "",
			DEBUG = "",
			TRACE = "✎",
		},
		max_height = function()
			return math.floor(vim.o.lines * 0.75)
		end,
		max_width = function()
			return math.floor(vim.o.columns * 0.75)
		end,
		on_open = function(win)
			vim.api.nvim_win_set_config(win, { zindex = 100 })
		end,
		stages = "fade_in_slide_out",
	},
	init = function()
		Util.on_very_lazy(function()
			vim.notify = require("notify")
		end)
	end,
}

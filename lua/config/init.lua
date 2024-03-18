local Util = require("util")

-- -@class VimConfig: VimOption

local M = {}
local defaults = {
	icons = {
		misc = {
			dots = "󰇘",
		},
		dap = {
			Stopped = { "󰁕 ", "DiagnosticWarn", "DapStoppedLine" },
			Breakpoint = " ",
			BreakpointCondition = " ",
			BreakpointRejected = { " ", "DiagnosticError" },
			LogPoint = ".>",
		},
		diagnostics = {
			Error = " ",
			Warn = " ",
			Hint = " ",
			Info = " ",
		},
		git = {
			added = " ",
			modified = " ",
			removed = " ",
		},
		kinds = {
			Array = " ",
			Boolean = "󰨙 ",
			Class = " ",
			Codeium = "󰘦 ",
			Color = " ",
			Control = " ",
			Collapsed = " ",
			Constant = "󰏿 ",
			Constructor = " ",
			Copilot = " ",
			Enum = " ",
			EnumMember = " ",
			Event = " ",
			Field = " ",
			File = " ",
			Folder = " ",
			Function = "󰊕 ",
			Interface = " ",
			Key = " ",
			Keyword = " ",
			Method = "󰊕 ",
			Module = " ",
			Namespace = "󰦮 ",
			Null = " ",
			Number = "󰎠 ",
			Object = " ",
			Operator = " ",
			Package = " ",
			Property = " ",
			Reference = " ",
			Snippet = " ",
			String = " ",
			Struct = "󰆼 ",
			TabNine = "󰏚 ",
			Text = " ",
			TypeParameter = " ",
			Unit = " ",
			Value = " ",
			Variable = "󰀫 ",
		},
		kind_filter = {
			default = {
				"Class",
				"Constructor",
				"Enum",
				"Field",
				"Function",
				"Interface",
				"Method",
				"Module",
				"Namespace",
				"Package",
				"Property",
				"Struct",
				"Trait",
			},
			markdown = false,
			help = false,
			-- you can specify a different filter for each filetype
			lua = {
				"Class",
				"Constructor",
				"Enum",
				"Field",
				"Function",
				"Interface",
				"Method",
				"Module",
				"Namespace",
				-- "Package", -- remove package since luals uses it for control flow structures
				"Property",
				"Struct",
				"Trait",
			},
		},
	},
}

M.json = {
	version = 3,
	data = {
		version = nil, ---@type string?
		news = {}, ---@type table<string, string>
		extras = {}, ---@type string[]
	},
}

function M.json.load()
	local path = vim.fn.stdpath("config") .. "/lazyvim.json"
	local f = io.open(path, "r")
	if f then
		local data = f:read("*a")
		f:close()
		local ok, json = pcall(vim.json.decode, data, { luanil = { object = true, array = true } })
		if ok then
			M.json.data = vim.tbl_deep_extend("force", M.json.data, json or {})
			if M.json.data.version ~= M.json.version then
				Util.json.migrate()
			end
		end
	end
end

local options

function M.setup(opts)
	options = vim.tbl_deep_extend("force", defaults, opts or {}) or {}

	-- autocmds can be loaded lazily when not opening a file
	local lazy_autocmds = vim.fn.argc(-1) == 0
	if not lazy_autocmds then
		M.load("autocmds")
	end

	local group = vim.api.nvim_create_augroup("LazyVim", { clear = true })
	vim.api.nvim_create_autocmd("User", {
		group = group,
		pattern = "VeryLazy",
		callback = function()
			if lazy_autocmds then
				M.load("autocmds")
			end
			M.load("keymaps")

			Util.format.setup()
			Util.news.setup()
			Util.root.setup()

			vim.api.nvim_create_user_command("LazyExtras", function()
				Util.extras.show()
			end, { desc = "Manage LazyVim extras" })

			vim.api.nvim_create_user_command("LazyHealth", function()
				vim.cmd([[Lazy! load all]])
				vim.cmd([[checkhealth]])
			end, { desc = "Load all plugins and run :checkhealth" })
		end,
	})

	Util.track("colorscheme")
	Util.try(function()
		if type(M.colorscheme) == "function" then
			M.colorscheme()
		else
			vim.cmd.colorscheme(M.colorscheme)
		end
	end, {
		msg = "Could not load your colorscheme",
		on_error = function(msg)
			Util.error(msg)
			vim.cmd.colorscheme("habamax")
		end,
	})
	Util.track()
end

---@param buf? number
---@return string[]?
function M.get_kind_filter(buf)
	buf = (buf == nil or buf == 0) and vim.api.nvim_get_current_buf() or buf
	local ft = vim.bo[buf].filetype
	if M.kind_filter == false then
		return
	end
	if M.kind_filter[ft] == false then
		return
	end
	---@diagnostic disable-next-line: return-type-mismatch
	return type(M.kind_filter) == "table" and type(M.kind_filter.default) == "table" and M.kind_filter.default or nil
end




---@param name "autocmds" | "options" | "keymaps"
function M.load(name)
	local function _load(mod)
		if require("lazy.core.cache").find(mod)[1] then
			Util.try(function()
				require(mod)
			end, { msg = "Failed loading " .. mod })
		end
	end
	-- always load lazyvim, then user file
	if M.defaults[name] or name == "options" then
		_load("lazyvim.config." .. name)
	end
	_load("config." .. name)
	if vim.bo.filetype == "lazy" then
		-- HACK: LazyVim may have overwritten options of the Lazy ui, so reset this here
		vim.cmd([[do VimResized]])
	end
	local pattern = "LazyVim" .. name:sub(1, 1):upper() .. name:sub(2)
	vim.api.nvim_exec_autocmds("User", { pattern = pattern, modeline = false })
end



setmetatable(M, {
	__index = function(_, key)
		if options == nil then
			return vim.deepcopy(defaults)[key]
		end
		return options[key]
	end,
})

return M

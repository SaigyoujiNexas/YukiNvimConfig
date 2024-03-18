return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
            plugins = { spelling = true },
        defaults = {
            mode = {"n", "v"},
            ["g"] = {name = "+goto"},
            ["<leader>g"] = { name = "+git"},
            ["<leader>f"] = {name = "+file/find"},
            ["<leader>s"] = {name = "+search"},
        }
    },
    config = function(_, opts)
        local wk = require("which-key")
        wk.setup(opts)
        wk.register(opts.defaults)
    end

}

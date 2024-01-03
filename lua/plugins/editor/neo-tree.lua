return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = { 
        "nvim-tree/nvim-web-devicons",
        "nvim-lua/plenary.nvim",
        "MuniTanjim/nui.nvim",
       "3rd/image.nvim",
    },
    cmd = "Neotree",
    deactivate = function()
        vim.cmd([[Neotree close]])
    end,
    init = function()
        if vim.fn.argc(-1) == 1 then
            local stat = vim.loop.fs_stat(vim.fn.argv(0))
            if stat and stat.type == "directory" then
                require("neo-tree")
            end
        end
    end,
    opts = {
        sources = {"filesystem", "buffers", "git_status", "document_symbols"}
    },
    config = function(_, opts)
        require("neo-tree").setup(opts)
    end 
}

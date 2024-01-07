return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
        "3rd/image.nvim",
    },
    cmd = "Neotree",
    keys = {
        {
            "<C-t>",
            function()
                require("neo-tree.command").execute({
                    toggle = true,
                })
            end,
            desc = "Explorer NeoTree",
        },
        {
            "<C-g>",
            function()
                require("neo-tree.command").execute({
                    source = "git_status",
                    toggle = true,
                })
            end
        }
    },
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
        sources = { "filesystem", "buffers", "git_status", "document_symbols" },
        filesystem = {
            follow_current_file = { enable = true },
            use_libuv_file_watcher = true,
        },
    },
    config = function(_, opts)
        require("neo-tree").setup(opts)
        vim.api.nvim_create_autocmd("TermClose", {
            pattern = "*lazygit",
            callback = function()
                if package.loaded["neo-tree.sources.git_status"] then
                    require("neo-tree.sources.git_status").refresh()
                end
            end,
        })
    end
}

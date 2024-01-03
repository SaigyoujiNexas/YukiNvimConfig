return {
    'akinsho/bufferline.nvim',
    version = "*",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
        options = {
            diagnostics = "nvim_lsp",
            options = {
                offsets = {
                    {
                        filetype = "NvimTree",
                        text = "File Explorer",
                        highlight = "Directory",
                        text_align = "left",
                    },
                },
            },
        }
    },
    config = function(_, opts)
        require("bufferline").setup(opts)
        vim.api.nvim_create_autocmd("BufAdd", {
            callback = function()
                vim.schedule(function()
                    pcall(nvim_bufferline)
                end)
            end,
        })
    end,
    keys = {
        { "<Tab>", ":bnext<CR>" }
    }
}

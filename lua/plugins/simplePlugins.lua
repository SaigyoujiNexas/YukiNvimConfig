return {
    "rrethy/vim-illuminate",
    "easymotion/vim-easymotion",
    "github/copilot.vim",
    {
        "numToStr/Comment.nvim",
        config = function()
            require('Comment').setup()
        end
    },

    {
        "HiPHish/rainbow-delimiters.nvim",
        dependencies = { "nvim-treesitter/nvim-treesitter" }
    },
    {
        'akinsho/bufferline.nvim',
        version = "*",
        dependencies = 'nvim-tree/nvim-web-devicons',
        config = function()
            require("bufferline").setup {
                options = {
                    options = {
                        diagnostics = "nvim_lsp",
                        offsets = { {
                            filetype = "NvimTree",
                            text = "File Explorer",
                            highlight = "Directory",
                            text_align = "left" } }, }
                }
            }
            vim.keymap.set("n", "<Tab>", ":bnext<CR>")
        end
    }
}

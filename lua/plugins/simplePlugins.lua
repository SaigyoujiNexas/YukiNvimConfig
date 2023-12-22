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
        'akinsho/bufferline.nvim', version = "*", dependencies = 'nvim-tree/nvim-web-devicons'
    }
}

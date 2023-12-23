return {
    "rrethy/vim-illuminate",
    "easymotion/vim-easymotion",
    {
        "zbirenbaum/copilot.lua",
        event = "InsertEnter",
        cmd = "Copilot",
        config = function()
            require("copilot").setup({
                suggestion = { enabled = false },
                panel = { enabled = false },
            })
        end
    },
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
        dependencies = { "nvim-tree/nvim-web-devicons",
            "catppuccin/nvim" },
        lazy = false,
        config = function()
            local macchiato = require("catppuccin.palettes").get_palette "macchiato"
            require("bufferline").setup {
                options = {
                    options = {
                        diagnostics = "nvim_lsp",
                        offsets = { {
                            filetype = "NvimTree",
                            text = "File Explorer",
                            highlight = "Directory",
                            text_align = "left" } }, },
                },
                highlights = require("catppuccin.groups.integrations.bufferline").get()
            }
        end,
        keys = {
            { "<Tab>", ":bnext<CR>" }
        }
    }
}

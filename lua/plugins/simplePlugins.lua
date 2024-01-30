return {
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
        "HiPHish/rainbow-delimiters.nvim",
        dependencies = {
            "nvim-treesitter/nvim-treesitter"
        }
    },
}

return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        require("nvim-treesitter.configs").setup {
            ensure_installed = { "c", "lua", "vim", "cpp", "bash", "json" },
            sync_install = false,
            auto_install = true,
            ignore_install = {},

            highlight = {
                enable = true,
            },
            indent = {
                enable = true,
            },
            rainbow = {
                enable = true,
                extended_mode = true,
                max_file_lines = 1000,
            }
        }
    end
}

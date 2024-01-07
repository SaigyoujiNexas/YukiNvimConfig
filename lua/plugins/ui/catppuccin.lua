return {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
        integrations = {
            cmp = true,
            dashboard = true,
            flash = true,
            gitsigns = true,
            headlines = true,
            illuminate = true,
            indent_blackline = { enable = true },
            mason = true,
            native_lsp = {
                enable = true,
                underlines = {
                    errors = { "undercurl" },
                    hints = { "undercurl" },
                    warnings = { "undercurl" },
                    information = { "undercurl" },
                },
            },
            neotree = true,
            noice = true,
            notify = true,
            rainbow_delimiters = true,
            telescope = true,
            treesitter = true,
            lsp_trouble = true,
            which_key = true,
        },
        flavour = "macchiato",
        transparent_background = true,
    },
    config = function(_, opts)
        require("catppuccin").setup(opts)
        vim.cmd.colorscheme "catppuccin"
    end
}

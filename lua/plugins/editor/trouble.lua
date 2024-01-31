return {
    "folke/trouble.nvim",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
    cmd = { "TroubleToggle", "Trouble" },
    opts = { use_diagnostic_signs = true },
    keys = {
        {
            "gpg",
            function()
                if require("trouble").is_open() then
                    require("trouble").previous({ skip_groups = true, jump = true })
                else
                    local ok, err = pcall(vim.diagnostic.goto_prev)
                    if not ok then
                        vim.notify(err, vim.log.levels.ERROR)
                    end
                end
            end,
            desc = "Previous trouble/quickfix item",
        },
        {
            "gng",
            function()
                if require("trouble").is_open() then
                    require("trouble").next({ skip_groups = true, jump = true })
                else
                    ok, err = pcall(vim.diagnostic.goto_next)
                    if not ok then
                        vim.notify(err, vim.log.levels.ERROR)
                    end
                end
            end,
            desc = "Next trouble/quickfix item",
        },
        {
            "<leader>lg",
            "<cmd>TroubleToggle loclist<cr>",
            desc = "Location List (Trouble)",
        },
        {
            "<leader>qg",
            "<cmd>TroubleToggle quickfix<cr>",
            desc = "Quickfix List (Trouble)",
        }


    }

}

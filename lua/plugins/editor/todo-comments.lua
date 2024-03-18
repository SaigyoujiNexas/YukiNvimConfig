return {
    "folke/todo-comments.nvim",
    cmd = { "TodoTrouble", "TodoTelescope" },
    config = true,
    keys = {
        { "]t", function() require("todo-comments").jump_next() end, desc = "Next todo comment" },
        { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous todo comment" },
        { "<leader>xt", "<cmd>TodoTrouble<cr>", desc = "Todo (Trouble)"},
        { "<leader>xs", "<cnd>TodoTelescope<cr>", desc = "Todo"},
    }
}

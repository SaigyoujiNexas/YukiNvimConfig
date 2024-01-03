return {
    "rcarriga/nvim-notify",
    opts = {
        background_color = "#000000",
        timeout = 3000,
        icons = {
            ERROR = "",
            WARN = "",
            INFO = "",
            DEBUG = "",
            TRACE = "✎",
        },
        stages = "fade_in_slide_out",

    },
    init = function()
        vim.notify = require("notify")
    end
}

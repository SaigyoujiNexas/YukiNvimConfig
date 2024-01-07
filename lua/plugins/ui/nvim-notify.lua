return {
    "rcarriga/nvim-notify",
    opts = {
        background_colour = "#000000",
        timeout = 3000,
        icons = {
            ERROR = "",
            WARN = "",
            INFO = "",
            DEBUG = "",
            TRACE = "✎",
        },
        stages = "fade_in_slide_out",
        on_open = function(win)
            vim.api.nvim_win_set_config(win, { zindex = 100 })
        end,

    },
    init = function()
    end
}

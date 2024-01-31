return {
    "nvim-telescope/telescope.nvim",
    branch = '0.1.x',
    cmd = "Telescope",
    dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-treesitter/nvim-treesitter',
        {
            'nvim-telescope/telescope-fzf-native.nvim',
            build = "make",
            enabled = vim.fn.executable("make") == 1,
        }
    },
    keys = {
        {
            "<leader>gc",
            "<cmd>Telescope git_commits<CR>",
            desc = "commits",
        },
        {
            "<leader>gs",
            "<cmd>Telescope git_status<CR>",
            desc = "status",
        },
        {
            "<leader>ff",
            "<cmd>Telescope find_files<CR>",
            desc = "find files",
        },
        {
            "<leader>fg",
            "<cmd>Telescope live_grep<CR>",
            desc = "live grep",
        },{
            "<leader>fb",
            "<cmd>Telescope buffers<CR>",
            desc = "buffers",
        },{
            "<leader>fh",
            "<cmd>Telescope help_tags<CR>",
            desc = "help tags",
        }

    },
    opts = {
        extensions = {
            fzf = {
                fuzzy = true,
                override_generic_sorter = true,
                override_file_sorter = true,
                case_mode = "smart_case",
            }
        }
    },
    config = function(_, opts)
        local function flash(prompt_bufnr)
            require("flash").jump({
                pattern = "^",
                label = { after = { 0, 0 } },
                search = {
                    mode = "search",
                    exclude = {
                        function(win)
                            return vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= "TelescopeResults"
                        end,
                    },
                },
                action = function(match)
                    local picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
                    picker:set_selection(match.pos[1] - 1)
                end,
            })
        end
        opts.defaults = vim.tbl_deep_extend("force", opts.defaults or {}, {
            mappings = { n = { s = flash }, i = { ["<c-s>"] = flash } },
        })
        local telescope = require('telescope')
        telescope.setup(opts)
        telescope.load_extension('fzf')
    end,
}

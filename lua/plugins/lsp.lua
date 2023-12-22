return {
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup({
                ui = {
                    icons = {
                        package_installed = "✓",
                        package_pending = "➜",
                        package_uninstalled = "✗"
                    }
                }
            })
        end
    },
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = { "neovim/nvim-lspconfig", "hrsh7th/cmp-nvim-lsp" },
        config = function()
            local capabilities = require('cmp_nvim_lsp').default_capabilities()
            local mason_lsp = require('mason-lspconfig')
            local lspconfig = require('lspconfig')
            mason_lsp.setup {
                ensure_installed = { "lua_ls", "clangd", "bashls" },
                automatic_installation = true,
            }
            mason_lsp.setup_handlers {
                function(server)
                    lspconfig[server].setup { capabilities = capabilities }
                end,
                ['tsserver'] = function()
                    lspconfig.tsserver.setup { settings = { completions = { completeFunctionCalls = true } } }
                end
            }
        end
    },
    {
        "neovim/nvim-lspconfig",
        config = function()
            local k = vim.keymap
            k.set("n", "gpg", vim.diagnostic.goto_prev)
            k.set("n", "gng", vim.diagnostic.goto_next)
            vim.api.nvim_create_autocmd('LspAttach', {
                group = vim.api.nvim_create_augroup('UserLspConfig', {}),
                callback = function(ev)
                    -- Enable completion triggered by <c-x><c-o>
                    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
                    local opts = { buffer = ev.buf }
                    k.set("n", "gd", vim.lsp.buf.definition, opts)
                    k.set("n", "gt", vim.lsp.buf.type_definition, opts)
                    k.set("n", "gi", vim.lsp.buf.implementation, opts)
                    k.set("n", "gr", vim.lsp.buf.references, opts)
                    --show documents
                    k.set("n", "K", vim.lsp.buf.hover, opts)
                    k.set("n", "rn", vim.lsp.buf.rename, opts)
                    -- format code by <leader>f in xmap and nmap
                    k.set("n", "<leader>f", vim.lsp.buf.format, opts)
                    k.set("x", "<leader>f", vim.lsp.buf.format, opts)
                    k.set("n", "<leader>a", vim.lsp.buf.code_action, opts)
                    k.set("x", "<leader>a", vim.lsp.buf.code_action, opts)
                    k.set("n", "<leader>ac", vim.lsp.buf.code_action, opts)
                    k.set("n", "<leader>as", vim.lsp.buf.code_action, opts)
                    --quick fix
                    --remap keys for applying refactor code actions.
                    k.set("n", "<leader>re", function() vim.lsp.buf.code_action({ only = { "refactor" } }) end, opts)
                    k.set("x", "<leader>r", function() vim.lsp.buf.code_action({ only = { "refactor" } }) end, opts)
                    k.set("n", "<leader>r", function() vim.lsp.buf.code_action { only = { "refactor" } } end, opts)
                    --code len actions
                    k.set("n", "<leader>cl", vim.lsp.buf.code_action, opts)
                    -- use ctrl-s for selection ranges
                    k.set("n", "<leader>qf", function()
                        vim.lsp.buf.code_action({
                            only = { "quickfix" },
                        })
                    end, opts)
                end,
            })
        end,
    }
}

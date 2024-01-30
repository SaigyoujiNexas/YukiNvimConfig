return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            {
                "folke/neoconf.nvim",
                cmd = "Neoconf",
                config = false,
                dependencies = { "nvim-lspconfig" }
            },
            {
                "folke/neodev.nvim",
                opts = {}
            },
            "mason.nvim",
            "williamboman/mason-lspconfig.nvim",
        },
        opts = {
            diagnostics = {
                underline = true,
                update_in_insert = false,
                virtual_text = {
                    spacing = 4,
                    source = "if_many",
                    prefix = "",
                },
                serverity_sort = true,
            },
            inlay_hints = {
                enabled = false,
            },
            capabilities = {},
            format = {
                formatting_options = nil,
                timeout_ms = nil,
            },
            servers = {
                lua_ls = {
                    settings = {
                        Lua = {
                            workspace = {
                                checkThirdParty = false,
                            },
                            completion = {
                                callSnippet = "Replace",
                            }
                        }
                    }
                },
                rust_analyzer = {
                    settings = {
                        ["rust-analyzer"] = {
                            cargo = {
                                allFeatures = true,
                                loadOutDirsFromCheck = true,
                                runBuildScripts = true,
                            },
                            checkOnSave = {
                                allFeatures = true,
                                command = "clippy",
                                extraArgs = { "--no-deps" },
                            },
                            procMacro = {
                                enable = true,
                                ignored = {
                                    ["async-trait"] = { "async_trait" },
                                    ["napt-derive"] = { "napi" },
                                    ["async-recursion"] = { "async_recursion" },
                                },
                            },
                        },
                    },
                },
            }
        },
        setup = {
        },
        config = function(_, opts)
            vim.diagnostic.config(vim.deepcopy(opts.diagnostics))
            local cmp_nvim_lsp = require("cmp_nvim_lsp")
            local capabilities = vim.tbl_deep_extend(
                "force",
                {},
                vim.lsp.protocol.make_client_capabilities(),
                cmp_nvim_lsp.default_capabilities(),
                opts.capabilities or {}
            )
            local function setup(server)
                capabilities.offsetEncoding = "utf-8"
                capabilities.offset_encoding = "utf-8"
                local server_opts = vim.tbl_deep_extend("force", {
                    capabilities = vim.deepcopy(capabilities),
                }, {})
                require("lspconfig")[server].setup(server_opts)
            end
            local function clangdsetup()
            end
            local mlsp = require("mason-lspconfig")
            mlsp.setup({ ensure_installed = ensure_installed, handlers = { setup, clangdsetup } })
            local k = vim.keymap
            -- k.set("n", "gpg", vim.diagnostic.goto_prev)
            -- k.set("n", "gng", vim.diagnostic.goto_next)
            vim.api.nvim_create_autocmd('LspAttach', {
                group = vim.api.nvim_create_augroup('UserLspConfig', {}),
                callback = function(ev)
                    -- Enable completion triggered by <c-x><c-o>
                    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
                    local opt = { buffer = ev.buf }
                    k.set("n", "gd", vim.lsp.buf.definition, opt)
                    k.set("n", "gt", vim.lsp.buf.type_definition, opt)
                    k.set("n", "gi", vim.lsp.buf.implementation, opt)
                    k.set("n", "gr", vim.lsp.buf.references, opt)
                    --show documents
                    k.set("n", "sd", vim.lsp.buf.hover, opt)
                    k.set("n", "rn", vim.lsp.buf.rename, opt)
                    -- format code by <leader>f in xmap and nmap
                    k.set("n", "<leader>f", vim.lsp.buf.format, opt)
                    k.set("x", "<leader>f", vim.lsp.buf.format, opt)
                    k.set("n", "<leader>a", vim.lsp.buf.code_action, opt)
                    k.set("x", "<leader>a", vim.lsp.buf.code_action, opt)
                    k.set("n", "<leader>ac", vim.lsp.buf.code_action, opt)
                    k.set("n", "<leader>as", vim.lsp.buf.code_action, opt)
                    --quick fix
                    --remap keys for applying refactor code actions.
                    k.set("n", "<leader>re", function() vim.lsp.buf.code_action({ only = { "refactor" } }) end, opt)
                    k.set("x", "<leader>r", function() vim.lsp.buf.code_action({ only = { "refactor" } }) end, opt)
                    k.set("n", "<leader>r", function() vim.lsp.buf.code_action { only = { "refactor" } } end, opt)
                    --code len actions
                    k.set("n", "<leader>cl", vim.lsp.codelens.run, opt)
                    -- use ctrl-s for selection ranges
                    k.set("n", "<leader>qf", function()
                        vim.lsp.buf.code_action({
                            only = { "quickfix" },
                        })
                    end, opt)
                end,
            })
        end,
    },
}

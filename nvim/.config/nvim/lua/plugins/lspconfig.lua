local M = {}

M.config = function()
    function on_attach(client, bufnr)
        --vim.lsp.set_log_level("debug")

        local function buf_set_keymap(...)
            vim.api.nvim_buf_set_keymap(bufnr, ...)
        end
        local function buf_set_option(...)
            vim.api.nvim_buf_set_option(bufnr, ...)
        end

        local cfg = {
            bind = true,
            floating_window = true,
            hint_enable = true,
            fix_pos = true
        }

        --require "lsp_signature".on_attach(cfg)
        --require'completion'.on_attach()

        buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

        -- Mappings.
        local opts = {noremap = true, silent = true}

        buf_set_keymap("n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts)
        buf_set_keymap("n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts)
        buf_set_keymap("n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>", opts)
        buf_set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
        buf_set_keymap("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
        buf_set_keymap("n", "<space>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
        buf_set_keymap("n", "<space>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
        buf_set_keymap("n", "<space>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", opts)
        buf_set_keymap("n", "<space>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
        buf_set_keymap("n", "<space>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
        buf_set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
        buf_set_keymap("n", "<space>e", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
        buf_set_keymap("n", "[d", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", opts)
        buf_set_keymap("n", "]d", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", opts)
        buf_set_keymap("n", "<space>q", "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>", opts)

        -- Set some keybinds conditional on server capabilities
        if client.resolved_capabilities.document_formatting then
            buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
        elseif client.resolved_capabilities.document_range_formatting then
            buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
        end
    end -- fn on_attach()

    -- lspInstall + lspconfig stuff

    local function setup_servers()
        local lsp_installer = require("nvim-lsp-installer")

        local servers = require "nvim-lsp-installer.servers"
        local util    = require("lspconfig/util")
        
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities.textDocument.completion.completionItem.documentationFormat = { "markdown", "plaintext" }
        capabilities.textDocument.completion.completionItem.snippetSupport = true
        capabilities.textDocument.completion.completionItem.preselectSupport = true
        capabilities.textDocument.completion.completionItem.insertReplaceSupport = true
        capabilities.textDocument.completion.completionItem.labelDetailsSupport = true
        capabilities.textDocument.completion.completionItem.deprecatedSupport = true
        capabilities.textDocument.completion.completionItem.commitCharactersSupport = true
        capabilities.textDocument.completion.completionItem.tagSupport = { valueSet = { 1 } }
        capabilities.textDocument.completion.completionItem.resolveSupport = {
            properties = {
                'documentation',
                'detail',
                'additionalTextEdits',
            }
        }
        capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)

        servers = {
            "ccls", "sumneko_lua", "ltex", "jedi_language_server", "zls", "rust_analyzer"
        }

        for _, lang in pairs(servers) do
            local server_available, requested_server = require('nvim-lsp-installer.servers').get_server(lang)
            if server_available then
                requested_server:on_ready(function ()
                    local client_opts = {}
                    local opts = {
                        on_attach = on_attach,
                        capabilities = capabilities,
                        root_dir = vim.loop.cwd,
                        launch = true,
                        flags = {
                            debounce_text_changes = 150
                        },
                        handlers = {
                            ["textDocument/publishDiagnostics"] = vim.lsp.with(
                                vim.lsp.diagnostic.on_publish_diagnostics, {
                                    virtual_text = true,
                                    underline = true,
                                    signs = true,
                                    update_in_insert = true,
                                }
                            )
                        }
                    }

                    if lang == "ccls" then
                        client_opts = vim.tbl_deep_extend("keep", opts, {
                            init_options = {
                                client = {
                                    snippetSupport = true
                                },
                                compilationDatabaseDirectory = "build";
                                index = {
                                    threads = 0;
                                };
                                cache = {
                                    directory = "/tmp/ccls";
                                };
                                highlight = {
                                    lsRangers = true;
                                };
                                clang = {
                                    excludeArgs = {
                                        "-mlongcalls",
                                        "-Wno-frame-address",
                                        "-fstrict-volatile-bitfields",
                                        "-fno-tree-switch-conversion",
                                        "-mtext-section-literals",
                                    },
                                }
                            },
                            cmd = { "ccls" },
                            filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
                            --root_dir = vim.loop.cwd,
                            root_dir = function(fname)
                                return util.root_pattern(--'build/compile_commands.json',
                                                        'compile_commands.json',
                                                        'compile_flags.txt',
                                                        '.git',
                                                        '.ccls')(fname) or util.path.dirname(fname)
                            end
                            -- root_dir = root_pattern("compile_commands.json", "compile_flags.txt", ".git", ".ccls") or dirname
                        })
                    end

                    if lang == "sumneko_lua" then
                        client_opts = vim.tbl_deep_extend("keep", opts, {
                            settings = {
                                Lua = {
                                    runtime = {
                                        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                                        version = 'LuaJIT',
                                    },
                                    diagnostics = {
                                        globals = {"vim"}
                                    },
                                    workspace = {
                                        library = {
                                            [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                                            [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
                                            --library = vim.api.nvim_get_runtime_file("", true),
                                        },
                                        maxPreload = 100000,
                                        preloadFileSize = 10000
                                    },
                                    telemetry = {
                                        enable = false
                                    }
                                }
                            }
                        })
                    end

                    if lang == "ltex" then
                        client_opts = vim.tbl_deep_extend("keep", opts, {
                            settings = {
                                ltex = {
                                    dictionary = {
                                        ['en-US'] = require("spell").userdict()
                                    }
                                }
                            }
                        })
                    end
                    requested_server:setup(client_opts)
                end)
                if not requested_server:is_installed() then
                    print("Installing " .. lang)
                    requested_server:install()
                end
            else
                print("Installing " .. lang)
                lsp_installer.install(lang)
            end
        end

        -- adds a check to see if any of the active clients have the capability
        -- textDocument/documentHighlight. without the check it was causing constant
        -- errors when servers didn't have that capability
        for _,client in ipairs(vim.lsp.get_active_clients()) do
            if client.resolved_capabilities.document_highlight then
                vim.cmd [[autocmd CursorHold  <buffer> lua vim.lsp.buf.document_highlight()]]
                vim.cmd [[autocmd CursorHoldI <buffer> lua vim.lsp.buf.document_highlight()]]
                vim.cmd [[autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()]]
                break -- only add the autocmds once
            end
        end
    end -- fn setup_servers()

    setup_servers()

    -- Automatically reload after `:LspInstall <server>` so we don't have to restart neovim
    --require "lspinstall".post_install_hook = function()
    --    setup_servers() -- reload installed servers
    --    vim.cmd("bufdo e") -- triggers FileType autocmd that starts the server
    --end

    -- replace the default lsp diagnostic letters with prettier symbols
    vim.fn.sign_define("LspDiagnosticsSignError", {text = "", numhl = "LspDiagnosticsDefaultError"})
    vim.fn.sign_define("LspDiagnosticsSignWarning", {text = "", numhl = "LspDiagnosticsDefaultWarning"})
    vim.fn.sign_define("LspDiagnosticsSignInformation", {text = "", numhl = "LspDiagnosticsDefaultInformation"})
    vim.fn.sign_define("LspDiagnosticsSignHint", {text = "", numhl = "LspDiagnosticsDefaultHint"})

    vim.cmd("autocmd CursorHold * lua vim.diagnostic.open_float()")
    vim.cmd("autocmd CursorHoldI * silent! lua vim.lsp.buf.signature_help()")

end -- fn M.config

return M

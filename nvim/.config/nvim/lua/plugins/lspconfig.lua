local M = {}

M.config = function()
    function on_attach(client, bufnr)
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
        require'completion'.on_attach()

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
        buf_set_keymap("n", "<space>e", "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>", opts)
        buf_set_keymap("n", "[d", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", opts)
        buf_set_keymap("n", "]d", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", opts)
        buf_set_keymap("n", "<space>q", "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>", opts)

        -- Set some keybinds conditional on server capabilities
        if client.resolved_capabilities.document_formatting then
            buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
        elseif client.resolved_capabilities.document_range_formatting then
            buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
        end
    end

    -- lspInstall + lspconfig stuff

    local function setup_servers()
        require "lspinstall".setup()

        local lspconf = require("lspconfig")
        local servers = require "lspinstall".installed_servers()
        local util    = require("lspconfig/util")
        
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities.textDocument.completion.completionItem.snippetSupport = true
        capabilities.textDocument.completion.completionItem.resolveSupport = {
            properties = {
                'documentation',
                'detail',
                'additionalTextEdits',
            }
        }

        for _, lang in pairs(servers) do
            lspconf[lang].setup {
                on_attach = on_attach,
                capabilities = capabilities,
                root_dir = vim.loop.cwd,
                flags = {
                    debounce_text_changes = 150
                }
            }
        end

        lspconf.lua.setup {
            on_attach = on_attach,
            capabilities = capabilities,
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
                            [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true
                        },
                        maxPreload = 100000,
                        preloadFileSize = 10000
                    },
                    telemetry = {
                        enable = false
                    }
                }
            }
        }

        lspconf.ccls.setup {
          on_attach = on_attach,
          capabilities = capabilities,
          init_options = {
            compilationDatabaseDirectory = "build";
            index = {
              threads = 0;
            };
            cache = {
              directory = "/tmp/ccls"
            };
            highlight = {
                lsRangers = true;
            };
          },
          cmd = { "ccls" },
          filetypes = { "c", "cpp", "objc", "objcpp" },
          --root_dir = vim.loop.cwd,
          root_dir = function(fname)
              return util.root_pattern('compile_commands.json',
                                       'compile_flags.txt',
                                       '.git',
                                       '.ccls')(fname) or util.path.dirname(fname)
          end
          -- root_dir = root_pattern("compile_commands.json", "compile_flags.txt", ".git", ".ccls") or dirname
        }
        
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
    end

    setup_servers()

    -- Automatically reload after `:LspInstall <server>` so we don't have to restart neovim
    require "lspinstall".post_install_hook = function()
        setup_servers() -- reload installed servers
        vim.cmd("bufdo e") -- triggers FileType autocmd that starts the server
    end

    -- replace the default lsp diagnostic letters with prettier symbols
    vim.fn.sign_define("LspDiagnosticsSignError", {text = "", numhl = "LspDiagnosticsDefaultError"})
    vim.fn.sign_define("LspDiagnosticsSignWarning", {text = "", numhl = "LspDiagnosticsDefaultWarning"})
    vim.fn.sign_define("LspDiagnosticsSignInformation", {text = "", numhl = "LspDiagnosticsDefaultInformation"})
    vim.fn.sign_define("LspDiagnosticsSignHint", {text = "", numhl = "LspDiagnosticsDefaultHint"})

    vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
        vim.lsp.diagnostic.on_publish_diagnostics, {
            virtual_text = true,
            underline = true,
            signs = true,
        }
    )
    vim.cmd("autocmd CursorHold * lua vim.lsp.diagnostic.show_line_diagnostics()")
    vim.cmd("autocmd CursorHoldI * silent! lua vim.lsp.buf.signature_help()")

end

return M

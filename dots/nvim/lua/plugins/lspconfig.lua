local M = {}

local get_capabilities = function()
    local default_capabilities = vim.lsp.protocol.make_client_capabilities()
    local modified_capabilities = {
        textDocument = {
            completion = {
                completionItem = {
                    documentationFormat = { "markdown", "plaintext" },
                    snippetSupport = true,
                    preselectSupport = true,
                    insertReplaceSupport = true,
                    labelDetailsSupport = true,
                    deprecatedSupport = true,
                    commitCharactersSupport = true,
                    tagSupport = { valueSet = { 1 } },
                    resolveSupport = {
                        properties = {
                            'documentation',
                            'detail',
                            'additionalTextEdits',
                        }
                    }
                }
            }
        }
    }
    local merged_capabilities = vim.tbl_deep_extend("force", default_capabilities, modified_capabilities)

    return require("cmp_nvim_lsp").default_capabilities(merged_capabilities)
end -- fn get_capabilities


local get_options = function()
    local opts = {
        autostart = true,
        on_attach = M.on_attach,
        capabilities = get_capabilities(),
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
    return opts
end -- fn get_options

local lsp_entry = function(server_name, auto_install)
    local auto_install_setting = false
    if auto_install ~= false then
        auto_install_setting = true
    end

    local path = vim.fn.expand("$HOME/.shelf/.nixmanaged")
    local exists = vim.fn.filereadable(path)
    if exists then
        auto_install_setting = false
    end

    return {
        lsp = server_name,
        auto_install = auto_install_setting,
    }
end --fn create_lsp_entry

M.servers = {
    clang    = lsp_entry("clangd"                     ),
    lua      = lsp_entry("lua_ls"                     ),
    latex    = lsp_entry("ltex"                       ),
    python   = lsp_entry("jedi_language_server"       ),
    rust     = lsp_entry("rust_analyzer"              ),
    cmake    = lsp_entry("cmake"                      ),
    proto    = lsp_entry("pbls"                       ),
    nix      = lsp_entry("nil_ls"              ,  true),
 -- yaml     = lsp_entry("yaml-language-server", false),
    ccls     = lsp_entry("ccls"                , false),
    vhdl     = lsp_entry("rust_hdl"            , false),
    zig      = lsp_entry("zls"                 , false),
    gdscript = lsp_entry("gdscript"            , false),
    tsclint  = lsp_entry("oxlint"              , false),
    tsclsp   = lsp_entry("typescript-language-server", false),
    tailwind = lsp_entry("tailwindcss-language-server", false),
}

local get_setup_handlers = function(default_opts)
    local lspconfig = require("lspconfig")
    local lspconfig_util = require("lspconfig/util")

    local opts = default_opts
    local setup_handlers_list = {
        [M.servers.rust.lsp] = function()
            local rust_opts = vim.tbl_deep_extend("force", opts, {
                settings = {
                    cargo = {
                        buildScripts = {
                            enable = true,
                        },
                    },
                    procMacro = {
                        enable = true
                    },
                }
            })
            lspconfig[M.servers.rust.lsp].setup(rust_opts)
        end,
        [M.servers.clang.lsp] = function()
            local clang_opts = vim.tbl_deep_extend("force", opts, {
                single_file_support = true,
                init_options = {
                    client = {
                        snippetSupport = true
                    },
                    compilationDatabaseDirectory = "build";
                    index = {
                        threads = 0;
                    };
                    cache = {
                        directory = "/tmp/clangd/";
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
                cmd = { "clangd" },
                filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "arduino" },
                --root_dir = util.root_pattern('compile_commands.json', '.ccls', 'compile_flags.txt', '.git')
                --root_dir = vim.loop.cwd,
                root_dir = function(fname)
                    return lspconfig_util.root_pattern(--'build/compile_commands.json',
                                            'compile_commands.json',
                                            'compile_flags.txt',
                                            '.git')(fname) or lspconfig_util.path.dirname(fname)
                end
                -- root_dir = root_pattern("compile_commands.json", "compile_flags.txt", ".git", ".ccls") or dirname
            })
            lspconfig[M.servers.clang.lsp].setup(clang_opts)
        end,
        [M.servers.lua.lsp] = function()
            local lua_opts = vim.tbl_deep_extend("force", opts, {
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
                            preloadFileSize = 10000,
                            checkThirdParty = "Apply",
                        },
                        telemetry = {
                            enable = false
                        }
                    }
                }
            })

            local proj_override = vim.env.LUA_LS_LIBRARY_PATH;
            if proj_override then
                local third_party_table = vim.split(proj_override, ":", {trimempty=true})
                lua_opts.settings.Lua.workspace.userThirdParty = third_party_table
            end

            lspconfig[M.servers.lua.lsp].setup(lua_opts)
        end,
        [M.servers.latex.lsp] = function()
            local latex_opts = vim.tbl_deep_extend("force", opts, {
                settings = {
                    ltex = {
                        dictionary = {
                            ['en-US'] = require("spell").userdict()
                        }
                    }
                }
            })
            lspconfig[M.servers.latex.lsp].setup(latex_opts)
        end,
        [M.servers.zig.lsp] = function()
            local zig_opts = vim.tbl_deep_extend("force", opts, {
                cmd = {"zls"},
                filetypes = {"zig", "zir"},
                root_dir = lspconfig_util.root_pattern("zls.json", ".git", "build.zig"),
                single_file_support = false
            })
            lspconfig[M.servers.zig.lsp].setup(zig_opts)
        end,
        [M.servers.nix.lsp] = function()
            local nix_opts = vim.tbl_deep_extend("force", opts, {
                root_dir = lspconfig_util.root_pattern("flake.nix", ".git"),
                single_file_support = true,
            })
            lspconfig[M.servers.nix.lsp].setup(nix_opts)
        end,
        [M.servers.vhdl.lsp] = function()
        --[[
            local vhdl_opts = vim.tbl_deep_extend("force", opts, {
                default_config = {
                    cmd = {"vhdl_ls"};
                    filetypes = { "vhdl" };
                    root_dir = function(fname)
                        return lspconfig_util.root_pattern('vhdl_ls.toml')(fname)
                    end;
                    settings = {};
                };
            })
            lspconfig[M.servers.vhdl].setup(vhdl_opts)
        --]]
        end,
        [M.servers.ccls.lsp] = function()
        --[[
            local ccls_opts = vim.tbl_deep_extend("force", opts, {
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
                root_dir = lspconfig_util.root_pattern('compile_commands.json', '.ccls', 'compile_flags.txt', '.git'),
                --root_dir = vim.loop.cwd,
                -- root_dir = function(fname)
                --     return util.root_pattern(--'build/compile_commands.json',
                --                             'compile_commands.json',
                --                             'compile_flags.txt',
                --                             '.git',
                --                             '.ccls')(fname) or util.path.dirname(fname)
                -- end
                -- root_dir = root_pattern("compile_commands.json", "compile_flags.txt", ".git", ".ccls") or dirname
                single_file_support = true,
            })
            lspconfig[M.servers.ccls].setup(ccls_opts)
        --]]
        end,
        [M.servers.tsclint.lsp] = function()
            local oxlint_opts = vim.tbl_deep_extend("force", opts, {
                cmd = { 'oxc_language_server' },
                filetypes = {
                    'javascript',
                    'javascriptreact',
                    'javascript.jsx',
                    'typescript',
                    'typescriptreact',
                    'typescript.tsx',
                },
                workspace_required = true,
                -- root_dir = function(bufnr, on_dir)
                --     vim.notify("Bufnr: "..bufnr, vim.log.levels.WARN)
                --     local fname = vim.api.nvim_buf_get_name(bufnr)
                --     local root_markers = lspconfig_util.insert_package_json({ '.oxlintrc.json' }, 'oxlint', fname)
                --     on_dir(vim.fs.dirname(vim.fs.find(root_markers, { path = fname, upward = true })[1]))
                -- end,
                root_dir = lspconfig_util.root_pattern('.oxlintrc.json'),
            })
            lspconfig[M.servers.tsclint.lsp].setup(oxlint_opts)
        end
    }
    return setup_handlers_list
end

local get_lsp_auto_install = function(auto_install)
    if auto_install == nil then auto_install = true end

    local t = {}
    for _,v in pairs(M.servers) do
        if v.auto_install == auto_install then
            table.insert(t, v.lsp)
        end
    end

    return t
end -- fn get_lsp_auto_install

M.on_attach = function(client, bufnr)

    -- LSP buffer settings
    local function buf_set_option(...)
        vim.api.nvim_buf_set_option(bufnr, ...)
    end

    local cfg = {
        bind = true,
        handler_opts = {
            border = "rounded"
        },
        hint_enable = false,
        cursorhold_update = false,
    }

    -- local cfg = {
    --     bind = true,
    --     floating_window = true,
    --     hint_enable = true,
    --     fix_pos = true
    -- }

    -- require("lsp_signature").on_attach(cfg, bufnr)

    buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

    require("mappings").lsp_configure(client, bufnr)
end -- fn M.on_attach()

M.config = function()
    local mason = require("mason")
    local mason_lspconfig = require("mason-lspconfig")
    local lspconfig = require("lspconfig")
    local lspconfig_util = require("lspconfig/util")
    local opts = get_options()
    local setup_handlers_list = get_setup_handlers(opts)

    local mason_setup_handlers = {
        function(server_name)
            lspconfig[server_name].setup(opts)
        end,
    }
    local mason_install_list = get_lsp_auto_install(true)
    for _,s in ipairs(setup_handlers_list) do
        if setup_handlers_list[s] ~= nil then
            mason_setup_handlers[s] = setup_handlers_list[s]
        end
        if mason_setup_handlers[s] ~= nil then
            mason_setup_handlers[s]() -- Setup the server
        else
            if mason_setup_handlers[1] ~= nil then
                mason_setup_handlers[1](s)
            end
        end
    end

    mason.setup()
    mason_lspconfig.setup {
        ensure_installed = get_lsp_auto_install(true),
        automatic_installation = false,
    }

    mason_lspconfig.setup_handlers (mason_setup_handlers)

    local manual_setup_handlers = {
        function(server_name)
            lspconfig[server_name].setup(opts)
        end,

    } -- manual_setup_handlers

    -- Setup manually configured LSPs
    local manual_install_list = get_lsp_auto_install(false)
    for _,s in ipairs(manual_install_list) do
        if setup_handlers_list[s] ~= nil then
            manual_setup_handlers[s] = setup_handlers_list[s]
        end
        if manual_setup_handlers[s] ~= nil then
            manual_setup_handlers[s]() -- Setup the server
        else
            if manual_setup_handlers[1] ~= nil then
                manual_setup_handlers[1](s)
            end
        end
    end

    -- adds a check to see if any of the active clients have the capability
    -- textDocument/documentHighlight. without the check it was causing constant
    -- errors when servers didn't have that capability
    for _,client in ipairs(vim.lsp.get_clients()) do
        if client.server_capabilities.document_highlight then
            vim.cmd [[autocmd CursorHold  <buffer> lua vim.lsp.buf.document_highlight()]]
            vim.cmd [[autocmd CursorHoldI <buffer> lua vim.lsp.buf.document_highlight()]]
            vim.cmd [[autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()]]
            break -- only add the autocmds once
        end
    end

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

    -- vim.cmd("autocmd CursorHold * lua vim.diagnostic.open_float()")
    -- vim.cmd("autocmd CursorHoldI * silent! lua vim.lsp.buf.signature_help()")

end -- fn M.config

return M

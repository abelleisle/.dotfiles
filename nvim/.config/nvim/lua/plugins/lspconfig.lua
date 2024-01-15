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

    return {
        lsp = server_name,
        auto_install = auto_install_setting,
    }
end --fn create_lsp_entry

M.servers = {
    clang  = lsp_entry("clangd"                     ),
    lua    = lsp_entry("lua_ls"                     ),
    latex  = lsp_entry("ltex"                       ),
    python = lsp_entry("jedi_language_server"       ),
    rust   = lsp_entry("rust_analyzer"              ),
    cmake  = lsp_entry("cmake"                      ),
    nix    = lsp_entry("nil_ls"              ,  true),
 -- yaml   = lsp_entry("yaml-language-server", false),
    ccls   = lsp_entry("ccls"                , false),
    vhdl   = lsp_entry("rust_hdl"            , false),
    zig    = lsp_entry("zls"                 , false),
}

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
    --vim.lsp.set_log_level("debug")

    local function buf_set_keymap(...)
        vim.api.nvim_buf_set_keymap(bufnr, ...)
    end
    local function buf_set_option(...)
        vim.api.nvim_buf_set_option(bufnr, ...)
    end

    -- local cfg = {
    --     bind = true,
    --     floating_window = true,
    --     hint_enable = true,
    --     fix_pos = true
    -- }

    local cfg = {
        bind = true,
        handler_opts = {
            border = "rounded"
        },
        hint_enable = false
    }

    require("lsp_signature").on_attach(cfg, bufnr)
    --require'completion'.on_attach()

    buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

    -- Mappings.
    local opts = function(desc)
        return {
            noremap = true,
            silent = true,
            desc = "LSP: " .. desc
        }
    end

    buf_set_keymap("n", "gD",        "<Cmd>lua vim.lsp.buf.declaration()<CR>",                                opts("goto declaration"))
    buf_set_keymap("n", "gd",        "<Cmd>lua vim.lsp.buf.definition()<CR>",                                 opts("goto definition"))
    buf_set_keymap("n", "gi",        "<cmd>lua vim.lsp.buf.implementation()<CR>",                             opts("goto implementation"))
    buf_set_keymap("n", "<space>D",  "<cmd>lua vim.lsp.buf.type_definition()<CR>",                            opts("goto type definition"))
    buf_set_keymap("n", "[d",        "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>",                           opts("goto previous use"))
    buf_set_keymap("n", "]d",        "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>",                           opts("goto next use"))
    buf_set_keymap("n", "K",         "<Cmd>lua vim.lsp.buf.hover()<CR>",                                      opts("start hover ???"))
    buf_set_keymap("n", "<space>k",  "<cmd>lua vim.lsp.buf.signature_help()<CR>",                             opts("signature"))
    buf_set_keymap("n", "<space>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>",                       opts("add workspace folder"))
    buf_set_keymap("n", "<space>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>",                    opts("remove workspace folder"))
    buf_set_keymap("n", "<space>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", opts("list workspace folders"))
    buf_set_keymap("n", "<space>rn", "<cmd>lua vim.lsp.buf.rename()<CR>",                                     opts("rename LSP object"))
    buf_set_keymap("n", "gr",        "<cmd>lua vim.lsp.buf.references()<CR>",                                 opts("see all object references"))
    buf_set_keymap("n", "<space>e",  "<cmd>lua vim.diagnostic.open_float()<CR>",                              opts("open diagnostic float (window)"))
    buf_set_keymap("n", "<space>q",  "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>",                         opts("set the location list ???"))

    -- Set some keybinds conditional on server capabilities
    if client.server_capabilities.document_formatting then
        buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>",       opts("format buffer"))
    elseif client.server_capabilities.document_range_formatting then
        buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts("format range"))
    end
end -- fn M.on_attach()

M.config = function()
    local mason = require("mason")
    local mason_lspconfig = require("mason-lspconfig")
    local lspconfig = require("lspconfig")
    local lspconfig_util = require("lspconfig/util")
    local opts = get_options()

    mason.setup()
    mason_lspconfig.setup {
        ensure_installed = get_lsp_auto_install(true),
        automatic_installation = false,
    }

    mason_lspconfig.setup_handlers {
        function(server_name)
            lspconfig[server_name].setup(opts)
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
                            preloadFileSize = 10000
                        },
                        telemetry = {
                            enable = false
                        }
                    }
                }
            })
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
    } -- mason_lspconfig.setup_handlers

    local manual_setup_handlers = {
        function(server_name)
            lspconfig[server_name].setup(opts)
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
    } -- manual_setup_handlers

    -- Setup manually configured LSPs
    local manual_install_list = get_lsp_auto_install(false)
    for _,s in ipairs(manual_install_list) do
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
    for _,client in ipairs(vim.lsp.get_active_clients()) do
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

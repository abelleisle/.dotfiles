-----------------------------------------------------------
--                    LSP SERVER LIST                    --
-----------------------------------------------------------
-- NOTE: If you add a server, you should also add its
-- config to `<nvim_root>/lsp/`.
local enabled_servers = {
    -- Lua
    "lua_ls",
    -- C/C++
    "clangd",
    -- CMake
    "neocmake",
    -- Nix
    "nil_ls",
    -- Rust
    "rust_analyzer",
    -- Zig
    "zls",
    -- Python
    "pylsp",
    -- Docker
    "docker_language_server",
}

local _disabled_servers = {
    -- Python
    -- "ruff",
    -- "ty", -- TODO: This may be a better solution in the future
    -- "basedpyright",
}

-------------------------------------------------------------
--                    LSP CONFIGURATION                    --
-------------------------------------------------------------

-- Imports
local mappings = require("mappings")

-- LSP export object (idk what comment to put here lol)
local M = {}

-- You are capable.
local function get_capabilities()
    local default_capabilities = vim.lsp.protocol.make_client_capabilities()
    -- TODO double check we don't need this
    -- local enhanced_capabilities = {
    --     textDocument = {
    --         completion = {
    --             completionItem = {
    --                 documentationFormat = { "markdown", "plaintext" },
    --                 snippetSupport = true,
    --                 preselectSupport = true,
    --                 insertReplaceSupport = true,
    --                 labelDetailsSupport = true,
    --                 deprecatedSupport = true,
    --                 commitCharactersSupport = true,
    --                 tagSupport = { valueSet = { 1 } },
    --                 resolveSupport = {
    --                     properties = {
    --                         "documentation",
    --                         "detail",
    --                         "additionalTextEdits",
    --                     },
    --                 },
    --             },
    --         },
    --     },
    -- }
    -- local merged_capabilities = vim.tbl_deep_extend("force", default_capabilities, enhanced_capabilities)

    -- Enhance with nvim-cmp if available
    local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
    if ok then
        return cmp_nvim_lsp.default_capabilities(default_capabilities)
    else
        vim.schedule(function()
            vim.notify("cmp_nvim_lsp wasn't found while setting up LSP", vim.log.levels.WARN)
        end)
    end
    return default_capabilities
end

-- Common LSP configuration
local function get_common_config()
    return {
        -- on_attach = LSP_on_attach,
        capabilities = get_capabilities(),
        flags = {
            debounce_text_changes = 150,
        },
    }
end

-- On attach function for LSP buffers
function LSP_on_attach(client, bufnr)
    -- Set omnifunc
    vim.api.nvim_set_option_value("omnifunc", "v:lua.vim.lsp.omnifunc", { buf = bufnr })

    -- Configure LSP mappings
    mappings.lsp_configure(client, bufnr)

    -- local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client.server_capabilities.documentHighlightProvider then
        local group = vim.api.nvim_create_augroup("LSPDocumentHighlight", { clear = false })
        vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
            buffer = bufnr,
            group = group,
            callback = vim.lsp.buf.document_highlight,
        })
        vim.api.nvim_create_autocmd("CursorMoved", {
            buffer = bufnr,
            group = group,
            callback = vim.lsp.buf.clear_references,
        })
    end
end

-- Setup function
function M.setup()
    -- Configure each server
    vim.lsp.config("*", get_common_config())

    -- Enable all configured servers
    vim.lsp.enable(enabled_servers)

    -- TODO look into using this instead of setting on_attach
    vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            local bufnr = args.buf
            LSP_on_attach(client, bufnr)
        end,
    })
end

return M

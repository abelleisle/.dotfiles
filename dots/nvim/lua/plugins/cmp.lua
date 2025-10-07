local M = {}

M.config = function()
    local cmp_present, cmp = pcall(require, "cmp")
    local lua_present, luasnip = pcall(require, "luasnip")

    if not cmp_present then
        vim.notify("cmp.config(): nvim_cmp is not present!", vim.log.levels.ERROR)
        return
    end

    if not lua_present then
        vim.notify("cmp.config(): luasnip is not present!", vim.log.levels.ERROR)
        return
    end

    vim.opt.completeopt = "menu,menuone,noselect"

    local has_words_before = function()
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
    end

    -- nvim-cmp setup
    cmp.setup({
        snippet = {
            expand = function(args)
                luasnip.lsp_expand(args.body)
            end,
        },
        -- formatting = {
        --     format = function(entry, vim_item) -- load lspkind icons
        --         vim_item.kind = string.format(
        --             "%s %s",
        --             require("plugins.lspkind_icons").icons[vim_item.kind],
        --             vim_item.kind
        --         )
        --
        --         vim_item.menu = ({
        --             nvim_lsp = "[LSP]",
        --             nvim_lua = "[Lua]",
        --             buffer = "[BUF]",
        --         })[entry.source.name]
        --
        --         return vim_item
        --     end,
        -- },
        formatting = {
            fields = { "kind", "abbr", "menu" },
            format = function(entry, vim_item)
                local kind = require("lspkind").cmp_format({ mode = "symbol_text", maxwidth = 50 })(entry, vim_item)
                local strings = vim.split(kind.kind, "%s", { trimempty = true })
                local type_str = "    (" .. (strings[2] or "") .. ")"
                kind.kind = " " .. (strings[1] or "") .. " "
                kind.menu = type_str
                    .. " "
                    .. (
                        ({
                            nvim_lsp = "[LSP]",
                            nvim_lua = "[Lua]",
                            buffer = "[BUF]",
                        })[entry.source.name] or ""
                    )

                return kind
            end,
        },
        window = {
            completion = cmp.config.window.bordered({}),
            documentation = cmp.config.window.bordered({}),
        },
        mapping = {
            ["<C-p>"] = cmp.mapping.select_prev_item(),
            ["<C-n>"] = cmp.mapping.select_next_item(),
            ["<C-u>"] = cmp.mapping.scroll_docs(-4),
            ["<C-d>"] = cmp.mapping.scroll_docs(4),
            ["<C-Space>"] = cmp.mapping.complete(),
            ["<C-e>"] = cmp.mapping.close(),
            ["<CR>"] = cmp.mapping.confirm({
                behavior = cmp.ConfirmBehavior.Replace,
                select = false,
            }),
            ["<Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_next_item()
                elseif luasnip.expand_or_jumpable() then
                    luasnip.expand_or_jump()
                elseif has_words_before() then
                    cmp.complete()
                else
                    fallback()
                end
            end, { "i", "s" }),

            ["<S-Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item()
                elseif luasnip.jumpable(-1) then
                    luasnip.jump(-1)
                else
                    fallback()
                end
            end, { "i", "s" }),
        },
        sources = cmp.config.sources({
            { name = "nvim_lsp" },
            { name = "luasnip" },
            { name = "buffer" },
            { name = "nvim_lua" },
            { name = "path" },
            { name = "codecompanion" },
        }),
    }) -- cmp.setup

    cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
            { name = "buffer" },
            { name = "path" },
        },
    })

    cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
            { name = "path" },
            { name = "cmdline" },
        }),
    })
end

M.luasnip = function()
    local lua_present, luasnip = pcall(require, "luasnip")

    if not lua_present then
        vim.notify("cmp.luasnip(): luasnip is not present!", vim.log.levels.ERROR)
        return
    end

    luasnip.config.set_config({
        history = true,
        updateevents = "TextChanged,TextChangedI",
    })

    -- Extend honza/vim-snippets "all" to LuaSnip all
    luasnip.filetype_extend("all", { "_" })

    require("luasnip.loaders.from_vscode").lazy_load()
    require("luasnip.loaders.from_snipmate").lazy_load()
    require("luasnip.loaders.from_lua").lazy_load()
end

return M

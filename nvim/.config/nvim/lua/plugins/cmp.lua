local M = {}
local present, cmp = pcall(require, "cmp")

M.config = function()
    vim.opt.completeopt = "menuone,noselect"

    -- nvim-cmp setup
    cmp.setup {
    snippet = {
        expand = function(args)
            require("luasnip").lsp_expand(args.body)
            vim.fn["UltiSnips#Anon"](args.body)
        end,
    },
    formatting = {
        format = function(entry, vim_item) -- load lspkind icons
            vim_item.kind = string.format(
                "%s %s",
                require("plugins.lspkind_icons").icons[vim_item.kind],
                vim_item.kind
            )

            vim_item.menu = ({
                nvim_lsp = "[LSP]",
                nvim_lua = "[Lua]",
                buffer = "[BUF]",
            })[entry.source.name]

            return vim_item
        end,
    },
    mapping = {
        ["<C-p>"] = cmp.mapping.select_prev_item(),
        ["<C-n>"] = cmp.mapping.select_next_item(),
        ["<C-d>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.close(),
        ["<CR>"] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
        },
        ["<Tab>"] = cmp.mapping(function(fallback)
            if vim.fn.complete_info()["selected"] == -1 and vim.fn["UltiSnips#CanExpandSnippet"]() == 1 then
                vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<C-R>=UltiSnips#ExpandSnippet()<CR>", true, true, true), "")
            elseif vim.fn["UltiSnips#CanJumpForwards"]() == 1 then
                vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<ESC>:call UltiSnips#JumpForwards()<CR>", true, true, true), "")
            elseif require("luasnip").expand_or_jumpable() then
                vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-expand-or-jump", true, true, true), "")
            elseif vim.fn.pumvisible() == 1 then
                vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<C-n>", true, true, true), "n")
            else
                fallback()
            end
        end, {"i", "s"}),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if vim.fn["UltiSnips#CanJumpBackwards"]() == 1 then
                vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<C-R>=UltiSnips#JumpBackwards()<CR>", true, true, true), "")
            elseif require("luasnip").jumpable(-1) then
                vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-jump-prev", true, true, true), "")
            elseif vim.fn.pumvisible() == 1 then
                vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<C-p>", true, true, true), "n")
            else
                fallback()
            end
        end, {"i", "s"})
    },
    sources = {
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "buffer" },
        { name = "nvim_lua" },
        { name = "path" },
        { name = "ultisnips" },
    },
    }

end

M.luasnip = function()
    local present, luasnip = pcall(require, "luasnip")
    if not present then
        return
    end

    luasnip.config.set_config {
        history = true,
        updateevents = "TextChanged,TextChangedI",
    }
    --require("luasnip/loaders/from_vscode").load { path = { chadrc_config.plugins.options.luasnip.snippet_path } }
end

return M

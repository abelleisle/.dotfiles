local M = {}

M.config = function()
    require("gitsigns").setup {
        signs = {
            add          = {text = "┃"},
            change       = {text = "┃"},
            delete       = {text = "▶"},
            changedelete = {text = "┃"},
            topdelete    = {text = "▲"},
        },
        signcolumn = true,
        numhl = false,
        linehl = false,
        watch_gitdir = {
            interval = 100
        },
        sign_priority = 5,
        status_formatter = nil, -- Use default
        current_line_blame = true,
        current_line_blame_opts = {
            delay = 1000,
            virt_text = true,
            virt_text_pos = 'eol'
        },
        diff_opts = {
            internal = true,
        }
    }

    -- vim.cmd("hi signcolumn guifg=bg   guibg=bg")
    -- vim.cmd("hi DiffAdd    guibg=yellow guifg=bg")
    -- vim.cmd("hi DiffChange guibg=cyan guifg=bg")
    -- vim.cmd("hi DiffDelete guibg=red guifg=bg")
end

return M

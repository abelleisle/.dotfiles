local M = {}

M.opts = {
        signs = {
            add = { text = "┃" },
            change = { text = "┃" },
            delete = { text = "▶" },
            changedelete = { text = "┃" },
            topdelete = { text = "▲" },
        },
        signcolumn = true,
        numhl = false,
        linehl = false,
        watch_gitdir = {
            interval = 100,
        },
        sign_priority = 5,
        status_formatter = nil, -- Use default
        current_line_blame = true,
        current_line_blame_opts = {
            delay = 1000,
            virt_text = true,
            virt_text_pos = "eol",
        },
        diff_opts = {
            internal = true,
        },
    }

-- M.config = function()
--     vim.cmd("hi signcolumn guifg=bg   guibg=bg")
--     vim.cmd("hi DiffAdd    guibg=yellow guifg=bg")
--     vim.cmd("hi DiffChange guibg=cyan guifg=bg")
--     vim.cmd("hi DiffDelete guibg=red guifg=bg")
-- end

local events = require("plugins").events
return {
    { -- Git modification signs
        "lewis6991/gitsigns.nvim",
        event = events.OpenFile,
        opts = M.opts
    },

}

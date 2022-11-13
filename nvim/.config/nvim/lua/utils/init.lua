local M = {}

-- blankline config
M.blankline = function()
    vim.g.indentLine_enabled = 1
    vim.g.indent_blankline_char = "▏"

    vim.g.indent_blankline_filetype_exclude = {"help", "terminal", "dashboard"}
    vim.g.indent_blankline_buftype_exclude = {"terminal"}

    vim.g.indent_blankline_show_trailing_blankline_indent = false
    vim.g.indent_blankline_show_first_indent_level = false
end

M.hideStuff = function()
    vim.api.nvim_create_autocmd(
       {"BufEnter", "BufWinEnter", "WinEnter", "CmdwinEnter"},
       {
           callback = function()
                local bufname = vim.fn.bufname('%')
                if string.sub(bufname, 1, string.len("NvimTree")) == "NvimTree" then
                    vim.opt.laststatus = 0
                else
                    vim.opt.laststatus = 2
                end
           end,
       }
   )
end

M.hsluv  = require("utils.hsluv")
M.colors = require("utils.colors")

return M

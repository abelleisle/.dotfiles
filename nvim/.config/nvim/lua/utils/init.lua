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

M.print_variable = function(var, depth)
    if depth == nil then depth = 0 end

    to_print = ""

    indent = string.rep("  ", depth)

    if type(var) == "table" then
        to_print = to_print .. string.format("%s{\n", indent)
        for name,val in pairs(var) do
            to_print = to_print .. string.format("%s%s = ", string.rep("  ", depth+1), name)
            to_print = to_print .. M.print_variable(val, depth+1)
        end
        to_print = to_print .. string.format("%s}\n", indent)
    elseif type(var) == "function" then
        to_print = to_print .. "function"
    elseif type(var) == "string" then
        to_print = to_print .. "\"" .. var .. "\""
    else
        to_print = to_print .. tostring(var)
    end

    if depth == 0 then
        print(to_print)
    else
        return to_print .. "\n"
    end
end

M.hsluv  = require("utils.hsluv")
M.colors = require("utils.colors")

return M

-- Core function: wraps specified lines with braces
local function wrap_lines_with_braces(start_line, end_line)
    local current_indent = vim.fn.indent(start_line)
    local indent_str = string.rep(" ", current_indent)

    -- Insert closing brace after end_line
    vim.api.nvim_buf_set_lines(0, end_line, end_line, true, { indent_str .. "}" })

    -- Insert opening brace before start_line
    vim.api.nvim_buf_set_lines(0, start_line - 1, start_line - 1, true, { indent_str .. "{" })

    -- Indent the lines between braces (shifted by 1 due to inserted open brace)
    for line = start_line + 1, end_line + 1 do
        vim.cmd(line .. ">")
    end

    -- Move cursor to opening brace line
    vim.api.nvim_win_set_cursor(0, { start_line, current_indent })
end

-- Operator function: called by vim after motion completes
-- Uses '[ and '] marks set by the g@ operator
local function indent_wrap_operator(type)
    local start_line = vim.fn.line("'[")
    local end_line = vim.fn.line("']")
    wrap_lines_with_braces(start_line, end_line)
end

-- Expose globally for operatorfunc (requires string reference)
_G.indent_wrap_operator = indent_wrap_operator

-- Normal mode: triggers operator-pending mode.
-- Supports: <leader>sb{motion}
-- See operator_trigger for same line and count-based wrapping.
local function operator_trigger()
    vim.o.operatorfunc = "v:lua.indent_wrap_operator"
    return "g@"
end

-- Normal mode: triggers operator-pending mode for same line and count-based wrapping.
-- Supports: <leader>sbb, {count}<leader>sbb
-- See operator_trigger for motion-base wrapping.
--
-- We need to use this special binding because running <leader>sb + b assumes
-- a 'b' motion. Creating a separate binding for <leader>sbb allows us to trigger the
-- operator on the current line without vim moving the cursor back a work.
local function operator_trigger_same_line()
    vim.o.operatorfunc = "v:lua.indent_wrap_operator"
    return "g@_"
end

-- Visual mode: wraps the visual selection
local function visual_wrap()
    -- Exit visual mode first to set '< '> marks properly
    local esc = vim.api.nvim_replace_termcodes("<Esc>", true, false, true)
    vim.api.nvim_feedkeys(esc, "nx", false)

    local start_line = vim.fn.line("'<")
    local end_line = vim.fn.line("'>")
    wrap_lines_with_braces(start_line, end_line)
end

local M = {
    operator_trigger = operator_trigger,
    operator_trigger_same_line = operator_trigger_same_line,
    visual_wrap = visual_wrap,
    -- Keep for backward compat if needed elsewhere
    indent_and_wrap_braces = function()
        local start_line = vim.fn.line(".")
        local end_line = start_line + vim.v.count1 - 1
        wrap_lines_with_braces(start_line, end_line)
    end,
}

return M

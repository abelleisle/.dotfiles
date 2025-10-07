local function get_selection_range()
    local start_line, end_line

    local mode = vim.api.nvim_get_mode().mode
    if mode == "v" or mode == "V" or mode == "\22" then
        local current_pos = vim.fn.getpos(".")
        local visual_pos = vim.fn.getpos("v")
        local current_line = current_pos[2]
        local visual_line = visual_pos[2]

        start_line = math.min(current_line, visual_line)
        end_line = math.max(current_line, visual_line)
    else
        -- TODO maybe find a place to use these if we exit visual mode??
        -- local start_pos = vim.fn.getpos("'<")
        -- local end_pos = vim.fn.getpos("'>")
        -- start_line = start_pos[2]
        -- end_line = end_pos[2]

        local count = vim.v.count1 -- Get count (defaults to 1 if not specified)
        start_line = vim.fn.line(".")
        end_line = start_line + count - 1
    end

    return {
        start_line = start_line,
        end_line = end_line,
    }
end

-- Function to indent and wrap lines with braces
local function indent_and_wrap_braces()
    local range = get_selection_range()
    local start_line = range.start_line
    local end_line = range.end_line

    local current_indent = vim.fn.indent(start_line)

    -- Insert closing brace with same indentation as start
    vim.api.nvim_buf_set_lines(0, end_line, end_line, true, { string.rep(" ", current_indent) .. "}" })

    -- Insert opening brace with same indentation as start
    vim.api.nvim_buf_set_lines(0, start_line - 1, start_line - 1, true, { string.rep(" ", current_indent) .. "{" })

    -- Indent the lines between braces
    for line = start_line + 1, end_line + 1 do
        vim.cmd(line .. ">")
    end

    -- TODO look into fixing final cursor positioning
    -- if vim.api.nvim_get_mode().mode == 'n' then
    --     -- Move cursor to the first non-blank character of the last line
    --     vim.cmd('normal! ' .. end_line + 1 .. 'G^')
    -- end
end

local M = {
    indent_and_wrap_braces = indent_and_wrap_braces,
}

return M

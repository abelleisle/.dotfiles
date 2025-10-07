local hsluv = require("utils.hsluv")

local M = {}

M.bg = "#000000"
M.fg = "#ffffff"
M.day_brightness = 0.3

--- Gets the current background color value. If no background exists
--- (transparent), returns 0x000000.
--- @param allow_transparent boolean|nil Optional parameter to allow transparent backgrounds (default: false)
--- @return number Returns number representing background value
function M.get_bg(allow_transparent)
    if allow_transparent == nil then
        allow_transparent = false
    end

    if allow_transparent then
        vim.notify("`allow_transparent` not currently supported", vim.log.levels.ERROR)
    end

    local normalBG = vim.api.nvim_get_hl(0, { name = "Normal" }).bg
    if normalBG ~= nil then
        return M.unify(normalBG)
    end

    local terminalBG = vim.g.terminal_color_background
    if terminalBG ~= nil then
        return M.unify(terminalBG)
    end

    local terminal0 = vim.g.terminal_color_0
    if terminal0 ~= nil then
        return M.unify(terminal0)
    end

    vim.notify("Using default background color in `get_bg`", vim.log.levels.WARN)
    return 0x000000
end

--- Gets the current foreground color value. If no foreground exists
--- (transparent), returns 0xFFFFFF.
--- @param allow_transparent boolean|nil Optional parameter to allow transparent backgrounds (default: false)
--- @return number Returns number representing background value
function M.get_fg(allow_transparent)
    if allow_transparent == nil then
        allow_transparent = false
    end

    if allow_transparent then
        vim.notify("`allow_transparent` not currently supported", vim.log.levels.ERROR)
    end

    local normalFG = vim.api.nvim_get_hl(0, { name = "Normal" }).fg
    if normalFG ~= nil then
        return M.unify(normalFG)
    end

    local terminalFG = vim.g.terminal_color_foreground
    if terminalFG ~= nil then
        return M.unify(terminalFG)
    end

    local terminal15 = vim.g.terminal_color_15
    if terminal15 ~= nil then
        return M.unify(terminal15)
    end

    vim.notify("Cound not find foreground highlight in `get_fg`", vim.log.levels.ERROR)
    return 0xFFFFFF
end

function M.get_palette(...)
    --- Gets terminal color number string
    --- @param cn number Color number
    local t = function(cn)
        local tc = vim.g["terminal_color_" .. cn]
        if tc == nil then
            vim.notify("Terminal color: " .. cn .. " does not exist!", vim.log.levels.ERROR)
            return nil
        end

        return tc
    end

    local bg = string.format("#%06X", M.get_bg() or 0x111111)
    local fg = string.format("#%06X", M.get_fg() or 0xeeeeee)
    local statusline_hl = vim.api.nvim_get_hl(0, { name = "StatusLine" })
    local status = statusline_hl.bg and string.format("#%06X", statusline_hl.bg) or nil

    return {
        bg = bg,
        fg = fg,
        magenta = t(13) or "#d16d9e",
        red = t(1) or "#ec5f67",
        orange = t(11) or "#ff8800", -- TODO Not sure is orange is 11
        yellow = t(3) or "#fabd2f",
        green = t(2) or "#afd700",
        cyan = t(6) or "#008080",
        blue = t(4) or "#0087d7",
        grey0 = M.blend(fg, bg, 0.16) or "#3c3836",
        grey1 = M.blend(fg, bg, 0.25) or "#504945",
        grey2 = M.blend(fg, bg, 0.33) or "#c0c0c0",
        grey3 = M.blend(fg, bg, 0.50) or "#3c3836",
        grey4 = M.blend(fg, bg, 0.66) or "#504945",
        grey5 = M.blend(fg, bg, 0.75) or "#c0c0c0",
        status = status,
    }
end

function M.tbl_deep_extend(...)
    local lhs = {}
    for _, rhs in ipairs({ ... }) do
        for k, v in pairs(rhs) do
            if type(lhs[k]) == "table" and type(v) == "table" then
                lhs[k] = M.tbl_deep_extend(lhs[k], v)
            else
                lhs[k] = v
            end
        end
    end
    return lhs
end

--- @param color number|string
--- @return number Returns the numeric color value
function M.unify(color)
    if type(color) == "number" then
        return math.max(math.min(color, 0xFFFFFF), 0x000000)
    elseif type(color) == "string" then
        return tonumber(color, 16)
    end

    vim.notify("Can't convert color " .. color .. " type (" .. type(color) .. ") to number", vim.log.levels.ERROR)
    return nil
end

function M.hl_to_hex(hl_num, default_hl)
    if hl_num ~= nil then
        if type(hl_num) == "string" then
            if vim.startswith(hl_num, "#") then
                return hl_num
            elseif string.lower(hl_num) == "none" then
                assert(default_hl ~= nil, "Default cannot be nil if hl_num is none")
                return default_hl
            else
                vim.notify("Invalid hl value " .. hl_num, vim.log.levels.ERROR)
            end
        end

        return string.format("#%06X", hl_num)
    end

    return nil
end

function M.hex_to_rgb(hex_str)
    local hex = "[abcdef0-9][abcdef0-9]"
    local pat = "^#(" .. hex .. ")(" .. hex .. ")(" .. hex .. ")$"
    hex_str = string.lower(hex_str)

    assert(string.find(hex_str, pat) ~= nil, "hex_to_rgb: invalid hex_str: " .. tostring(hex_str))

    local r, g, b = string.match(hex_str, pat)
    return { tonumber(r, 16), tonumber(g, 16), tonumber(b, 16) }
end

function M.hex_to_norm_rgb(hex_str)
    local c = M.hex_to_rgb(hex_str)
    return { c[1] / 255, c[2] / 255, c[3] / 255 }
end

---@param fg_hex string|number foreground color
---@param bg_hex string|number background color
---@param alpha number number between 0 and 1. 0 results in bg, 1 results in fg
function M.blend(fg_hex, bg_hex, alpha)
    if type(fg_hex) == "number" then
        fg_hex = string.format("#%06X", fg_hex)
    end

    if type(bg_hex) == "number" then
        bg_hex = string.format("#%06X", bg_hex)
    end

    local bg = M.hex_to_rgb(bg_hex)
    local fg = M.hex_to_rgb(fg_hex)

    local blendChannel = function(i)
        local ret = (alpha * fg[i] + ((1 - alpha) * bg[i]))
        return math.floor(math.min(math.max(0, ret), 255) + 0.5)
    end

    return string.format("#%02X%02X%02X", blendChannel(1), blendChannel(2), blendChannel(3))
end

function M.darken(hex, amount, bg)
    return M.blend(hex, bg or M.bg, math.abs(amount))
end

function M.lighten(hex, amount, fg)
    return M.blend(hex, fg or M.fg, math.abs(amount))
end

function M.brighten(color, percentage)
    local hsl = hsluv.hex_to_hsluv(color)
    local larpSpace = 100 - hsl[3]
    if percentage < 0 then
        larpSpace = hsl[3]
    end
    hsl[3] = hsl[3] + larpSpace * percentage
    return hsluv.hsluv_to_hex(hsl)
end

function M.invertColor(color)
    if color ~= "NONE" then
        local hsl = hsluv.hex_to_hsluv(color)
        hsl[3] = 100 - hsl[3]
        if hsl[3] < 40 then
            hsl[3] = hsl[3] + (100 - hsl[3]) * M.day_brightness
        end
        return hsluv.hsluv_to_hex(hsl)
    end
    return color
end

-- Simple string interpolation.
--
-- Example template: "${name} is ${value}"
--
---@param str string template string
---@param tbl table key value pairs to replace in the string
function M.template(str, tbl)
    local function get_path(t, path)
        for segment in string.gmatch(path, "[^.]+") do
            if type(t) == "table" then
                t = t[segment]
            end
        end
        return t
    end
    return (
        str:gsub("($%b{})", function(w)
            local path = w:sub(3, -2)
            return get_path(tbl, path) or w
        end)
    )
end

-- Template values in a table recursivly
---@param table table the table to be replaced
---@param values table the values to be replaced by the template strings in the table passed in
function M.template_table(table, values)
    -- if the value passed is a string the return templated resolved string
    if type(table) == "string" then
        return M.template(table, values)
    end

    -- If the table passed in is a table then iterate though the children and call template table
    for key, value in pairs(table) do
        table[key] = M.template_table(value, values)
    end

    return table
end

function M.terminal(theme)
    vim.g.terminal_color_0 = theme.colors.base00
    vim.g.terminal_color_1 = theme.colors.red
    vim.g.terminal_color_2 = theme.colors.green
    vim.g.terminal_color_3 = theme.colors.yellow
    vim.g.terminal_color_4 = theme.colors.blue
    vim.g.terminal_color_5 = theme.colors.magenta
    vim.g.terminal_color_6 = theme.colors.cyan
    vim.g.terminal_color_7 = theme.colors.grey

    vim.g.terminal_color_8 = theme.colors.blue_dim
    vim.g.terminal_color_9 = theme.colors.red
    vim.g.terminal_color_10 = theme.colors.green
    vim.g.terminal_color_11 = theme.colors.yellow
    vim.g.terminal_color_12 = theme.colors.blue_br
    vim.g.terminal_color_13 = theme.colors.magenta
    vim.g.terminal_color_14 = theme.colors.cyan
    vim.g.terminal_color_15 = theme.colors.white
end

function M.syntax(tbl)
    for group, colors in pairs(tbl) do
        M.highlight(group, colors)
    end
end

function M.highlight(group, color)
    local style = color.style and "gui=" .. color.style or "gui=NONE"
    local fg = color.fg and "guifg=" .. color.fg or "guifg=NONE"
    local bg = color.bg and "guibg=" .. color.bg or "guibg=NONE"
    local sp = color.sp and "guisp=" .. color.sp or ""
    -- Vim will still apply 'cterm' styles when 'termguicolors' is on.
    -- Manually clear it to provide consistent styles of CursorLine, StatusLine, and etc.
    local hl = "highlight " .. group .. " " .. style .. " " .. fg .. " " .. bg .. " " .. sp .. " cterm=NONE"

    vim.cmd(hl)
    if color.link then
        vim.cmd("highlight! link " .. group .. " " .. color.link)
    end
end

function M.load(theme, exec_autocmd)
    -- only needed to clear when not the default colorscheme
    if vim.g.colors_name then
        vim.cmd("hi clear")
    end

    vim.cmd("set background=dark")
    vim.cmd("set termguicolors")
    vim.g.colors_name = theme.name

    local hlgroups = M.template_table(theme.config.hlgroups, theme.colors)
    local groups = M.tbl_deep_extend(theme.groups, hlgroups)

    M.syntax(groups)

    if theme.config.terminal_colors then
        M.terminal(theme)
    end

    if exec_autocmd then
        vim.cmd([[doautocmd ColorScheme]])
    end
end

return M

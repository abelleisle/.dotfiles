local colorutils = require("utils.colors")

-- local colors = require(vim.g.theme .. ".colors")
--
-- local white = colors.white
-- local darker_black = colors.darker_black
-- local black = colors.black
-- local black2 = colors.black2
-- local one_bg = colors.one_bg
-- local one_bg2 = colors.one_bg2
-- local one_bg3 = colors.one_bg3
-- local light_grey = colors.light_grey
-- local grey = colors.gray
-- local grey_fg = colors.grey_fg
-- local red = colors.red
-- local line = colors.gray
-- local green = colors.green
-- local nord_blue = colors.blue
-- local blue = colors.blue
-- local yellow = colors.yellow
-- local purple = colors.purple

-- for guifg , bg

--------------
--  COLORS  --
--------------

if vim.g.colors == nil then
    vim.g.colors = {
        bg = "#000000",
        fg = "#eeeeee",
        magenta = "#d16d9e",
        red = "#ec5f67",
        orange = "#ff8800",
        yellow = "#fabd2f",
        green = "#afd700",
        cyan = "#008080",
        blue = "#0087d7",
        grey0 = "#3c3836",
        grey1 = "#504945",
        grey2 = "#c0c0c0",
    }
end
local c = vim.g.colors

-------------
--  UTILS  --
-------------

local function fg(group, color)
    if color ~= nil then
        -- cmd("hi " .. group .. " guifg=" .. color)
        vim.api.nvim_set_hl(0, group, { fg = color })
    end
end

local function bg(group, color)
    if color ~= nil then
        vim.api.nvim_set_hl(0, group, { bg = color })
        -- cmd("hi " .. group .. " guibg=" .. color)
    end
end

local function fg_bg(group, fgcol, bgcol)
    if fgcol ~= nil and bgcol ~= nil then
        -- cmd("hi " .. group .. " guifg=" .. fgcol .. " guibg=" .. bgcol)
        vim.api.nvim_set_hl(0, group, { fg = fgcol, bg = bgcol })
    end
end

local M = {}

-----------------------------------------------------
--                    CONFIGURE                    --
-----------------------------------------------------
-- Sorry this function body isn't indented.
-- It's kinda gross, BUT IMO it's easier to read
-- this way.
--
-- We need this fuction because we use an
-- autocommand (`ColorScheme`) to update our
-- highlights (execute this function). If we just
-- call `require('highlights')` only the first
-- call will execute code, the rest will use the
-- cached results.
M.config = function()
    local normal_hl = vim.api.nvim_get_hl(0, { name = "Normal" })
    local normal_bg = colorutils.hl_to_hex(normal_hl.bg or vim.g.terminal_color_0, "#000000")
    local normal_fg = colorutils.hl_to_hex(normal_hl.fg or vim.g.terminal_color_15, "#FFFFFF")

    ---------------
    --    UI     --
    ---------------
    fg_bg("FloatBorder", c.grey1, "NONE")
    fg_bg("NormalFloat", c.fg, "NONE")

    ---------------
    --  PLUGINS  --
    ---------------

    -- Brightend foreground colors
    local fg_green = colorutils.brighten(c.green, 20)
    local fg_yellow = colorutils.brighten(c.yellow, 20)

    -- Customization for Pmenu
    -- vim.api.nvim_set_hl(0, "PmenuSel", { bg = "#282C34", fg = "NONE" })
    -- vim.api.nvim_set_hl(0, "Pmenu", { fg = c.fg, bg = "#22252A" })
    vim.api.nvim_set_hl(0, "PmenuSel", { bg = c.red, fg = "NONE" })
    vim.api.nvim_set_hl(0, "Pmenu", { fg = c.fg, bg = c.yellow })

    vim.api.nvim_set_hl(0, "CmpItemAbbrDeprecated", { fg = c.grey0, bg = "NONE", strikethrough = true })
    vim.api.nvim_set_hl(0, "CmpItemAbbrMatch", { fg = c.blue, bg = "NONE", bold = true })
    vim.api.nvim_set_hl(0, "CmpItemAbbrMatchFuzzy", { fg = c.blue, bg = "NONE", bold = true })
    vim.api.nvim_set_hl(0, "CmpItemMenu", { fg = c.magenta, bg = "NONE", italic = true })

    vim.api.nvim_set_hl(0, "CmpItemKindField", { fg = c.fg, bg = c.red })
    vim.api.nvim_set_hl(0, "CmpItemKindProperty", { fg = c.fg, bg = c.red })
    vim.api.nvim_set_hl(0, "CmpItemKindEvent", { fg = c.fg, bg = c.red })

    vim.api.nvim_set_hl(0, "CmpItemKindText", { fg = fg_green, bg = c.green })
    vim.api.nvim_set_hl(0, "CmpItemKindEnum", { fg = fg_green, bg = c.green })
    vim.api.nvim_set_hl(0, "CmpItemKindKeyword", { fg = fg_green, bg = c.green })
    vim.api.nvim_set_hl(0, "CmpItemKindConstant", { fg = fg_yellow, bg = c.yellow })
    vim.api.nvim_set_hl(0, "CmpItemKindConstructor", { fg = fg_yellow, bg = c.yellow })
    vim.api.nvim_set_hl(0, "CmpItemKindReference", { fg = fg_yellow, bg = c.yellow })

    vim.api.nvim_set_hl(0, "CmpItemKindFunction", { fg = c.fg, bg = c.magenta })
    vim.api.nvim_set_hl(0, "CmpItemKindStruct", { fg = c.fg, bg = c.magenta })
    vim.api.nvim_set_hl(0, "CmpItemKindClass", { fg = c.fg, bg = c.magenta })
    vim.api.nvim_set_hl(0, "CmpItemKindModule", { fg = c.fg, bg = c.magenta })
    vim.api.nvim_set_hl(0, "CmpItemKindOperator", { fg = c.fg, bg = c.magenta })

    vim.api.nvim_set_hl(0, "CmpItemKindVariable", { fg = c.fg, bg = c.grey1 })
    vim.api.nvim_set_hl(0, "CmpItemKindFile", { fg = c.fg, bg = c.grey1 })

    vim.api.nvim_set_hl(0, "CmpItemKindUnit", { fg = c.fg, bg = c.orange })
    vim.api.nvim_set_hl(0, "CmpItemKindSnippet", { fg = c.fg, bg = c.orange })
    vim.api.nvim_set_hl(0, "CmpItemKindFolder", { fg = c.fg, bg = c.orange })

    vim.api.nvim_set_hl(0, "CmpItemKindMethod", { fg = c.grey2, bg = c.blue })
    vim.api.nvim_set_hl(0, "CmpItemKindValue", { fg = c.grey2, bg = c.blue })
    vim.api.nvim_set_hl(0, "CmpItemKindEnumMember", { fg = c.grey2, bg = c.blue })

    vim.api.nvim_set_hl(0, "CmpItemKindInterface", { fg = c.grey2, bg = c.cyan })
    vim.api.nvim_set_hl(0, "CmpItemKindColor", { fg = c.grey2, bg = c.cyan })
    vim.api.nvim_set_hl(0, "CmpItemKindTypeParameter", { fg = c.grey2, bg = c.cyan })

    -------------------------------
    -- Notify

    -- TODO maybe we want to keep some version of this so we don't overwrite
    -- the highlight provided by the loaded colorscheme.
    -- At the moment, this will always overwrite it with `normal_bg`. If
    -- we use the "non-nil" branch below, it will only set the value the
    -- first time we set the colorscheme. This also means that we don't
    -- update the highlight if the background polarity changes.
    -- local notify_bg = vim.api.nvim_get_hl(0, { name = "NotifyBackground"} )
    -- if notify_bg.bg == nil then
    bg("NotifyBackground", normal_bg)
    -- end

    -- blankline

    -- fg("IndentBlanklineChar", line)

    -- misc --
    fg("LineNrAbove", c.grey1)
    fg("LineNr", c.yellow)
    fg("LineNrBelow", c.grey1)
    -- fg("LineNr", grey)
    -- fg("Comment", grey)
    -- fg("NvimInternalError", red)
    -- fg("VertSplit", line)
    -- fg("EndOfBuffer", black)

    -- Pmenu
    -- bg("Pmenu", one_bg)
    -- bg("PmenuSbar", one_bg2)
    -- bg("PmenuSel", green)
    -- bg("PmenuThumb", nord_blue)
    -- inactive statuslines as thin splitlines
    -- cmd("hi! StatusLineNC gui=underline guifg=" .. line)

    -- line n.o
    -- cmd "hi clear CursorLine"
    -- fg("cursorlinenr", white)

    -------------------------------
    -- Git Signs

    fg("GitSignsAdd", c.green)
    fg("GitSignsChange", c.orange)
    fg("GitSignsDelete", c.red)
    fg("GitSignsChangedelete", c.red)
    fg("GitSignsTopdelete", c.red)

    -- NvimTree
    -- fg("NvimTreeFolderIcon", blue)
    -- fg("NvimTreeFolderName", blue)
    -- fg("NvimTreeOpenedFolderName", blue)
    -- fg("NvimTreeEmptyFolderName", blue)
    -- fg("NvimTreeIndentMarker", one_bg2)
    -- fg("NvimTreeVertSplit", darker_black)
    -- bg("NvimTreeVertSplit", darker_black)
    -- fg("NvimTreeEndOfBuffer", darker_black)
    --
    -- fg("NvimTreeRootFolder", darker_black)
    -- bg("NvimTreeNormal", darker_black)
    -- fg_bg("NvimTreeStatuslineNc", darker_black, darker_black)
    -- fg_bg("NvimTreeWindowPicker", red, black2)

    -- telescope
    -- fg("TelescopeBorder", line)
    -- fg("TelescopePromptBorder", line)
    -- fg("TelescopeResultsBorder", line)
    -- fg("TelescopePreviewBorder", grey)

    -- LspDiagnostics ---

    -- error / warnings
    -- fg("LspDiagnosticsSignError", red)
    -- fg("LspDiagnosticsVirtualTextError", red)
    -- fg("LspDiagnosticsSignWarning", yellow)
    -- fg("LspDiagnosticsVirtualTextWarning", yellow)

    -- info
    -- fg("LspDiagnosticsSignInformation", green)
    -- fg("LspDiagnosticsVirtualTextInformation", green)

    -- hint
    -- fg("LspDiagnosticsSignHint", purple)
    -- fg("LspDiagnosticsVirtualTextHint", purple)

    -- bufferline

    -- fg_bg("BufferLineFill", grey_fg, black2)
    -- fg_bg("BufferLineBackground", light_grey, black2)
    --
    -- fg_bg("BufferLineBufferVisible", light_grey, black2)
    -- fg_bg("BufferLineBufferSelected", white, black)
    --
    -- cmd "hi BufferLineBufferSelected gui=bold"

    -- tabs
    -- fg_bg("BufferLineTab", light_grey, one_bg3)
    -- fg_bg("BufferLineTabSelected", black2, nord_blue)
    -- fg_bg("BufferLineTabClose", red, black)
    --
    -- fg_bg("BufferLineIndicator", black2, black2)
    -- fg_bg("BufferLineIndicatorSelected", black, black)

    -- separators
    -- fg_bg("BufferLineSeparator", black2, black2)
    -- fg_bg("BufferLineSeparatorVisible", black2, black2)
    -- fg_bg("BufferLineSeparatorSelected", black, black2)

    -- modified buffers
    -- fg_bg("BufferLineModified", red, black2)
    -- fg_bg("BufferLineModifiedVisible", red, black2)
    -- fg_bg("BufferLineModifiedSelected", green, black)

    -- close buttons
    -- fg_bg("BufferLineCLoseButtonVisible", light_grey, black2)
    -- fg_bg("BufferLineCLoseButton", light_grey, black2)
    -- fg_bg("BufferLineCLoseButtonSelected", red, black)

    -- dashboard

    -- fg("DashboardHeader", grey_fg)
    -- fg("DashboardCenter", grey_fg)
    -- fg("DashboardShortcut", grey_fg)
    -- fg("DashboardFooter", grey_fg)

    -- set bg color for nvim ( so nvim wont use terminal bg)

    -- NvChad themes bg colors
    -- Onedark #1e222a
    -- Gruvbox  #222526
    -- tomorrow night #1d1f21

    -- bg("Normal", "#1e222a") -- change the hex color here.

    -------------------------------
    -- Avante Chat Highlights

    local win_sep = vim.api.nvim_get_hl(0, { name = "WinSeparator" })
    local win_sep_bg = colorutils.hl_to_hex(win_sep.bg)
    local win_sep_fg = colorutils.hl_to_hex(win_sep.fg)

    fg_bg("AvanteSidebarWinSeparator", win_sep_fg, win_sep_bg)

    fg_bg("AvanteTitle", c.bg, c.cyan)
    fg_bg("AvanteReversedTitle", c.cyan, c.bg)
    fg_bg("AvanteSubtitle", c.bg, c.blue)
    fg_bg("AvanteReversedSubtitle", c.blue, c.bg)
    fg_bg("AvanteThirdTitle", c.grey2, c.grey1)
    fg_bg("AvanteReversedThirdTitle", c.grey1, c.bg)

    fg_bg("AvanteSidebarNormal", c.fg, c.bg)
    fg_bg("AvantePromptInputBorder", c.grey1, c.bg)
    fg_bg("AvanteSidebarWinHorizontalSeparator", c.grey1, c.bg)

    ------------------
    --  STATUS BAR  --
    ------------------

    require("plugins.statusline").config()
end

return M

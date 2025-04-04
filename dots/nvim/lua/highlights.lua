local cmd = vim.cmd

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
      bg      = '#000000',
      fg      = '#eeeeee',
      magenta = '#d16d9e',
      red     = '#ec5f67',
      orange  = '#ff8800',
      yellow  = '#fabd2f',
      green   = '#afd700',
      cyan    = '#008080',
      blue    = '#0087d7',
      grey0   = '#3c3836',
      grey1   = '#504945',
      grey2   = '#c0c0c0',
    }
end

-------------
--  UTILS  --
-------------

local function fg(group, color)
    if (color ~= nil) then
        cmd("hi " .. group .. " guifg=" .. color)
    end
end

local function bg(group, color)
    if (color ~= nil) then
        cmd("hi " .. group .. " guibg=" .. color)
    end
end

local function fg_bg(group, fgcol, bgcol)
    if (fgcol ~= nil and bgcol ~= nil) then
        cmd("hi " .. group .. " guifg=" .. fgcol .. " guibg=" .. bgcol)
    end
end

---------------
--  PLUGINS  --
---------------

-- blankline

-- fg("IndentBlanklineChar", line)

-- misc --
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

fg("GitSignsAdd",          vim.g.colors.green)
fg("GitSignsChange",       vim.g.colors.orange)
fg("GitSignsDelete",       vim.g.colors.red)
fg("GitSignsChangedelete", vim.g.colors.red)
fg("GitSignsTopdelete",    vim.g.colors.red)

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

local win_sep = vim.api.nvim_get_hl(0, { name = "WinSeparator"} )
local win_sep_bg = colorutils.hl_to_hex(win_sep.bg)
local win_sep_fg = colorutils.hl_to_hex(win_sep.fg)

fg_bg("AvanteSidebarWinSeparator",   win_sep_fg, win_sep_bg)

fg_bg("AvanteTitle",              vim.g.colors.bg,    vim.g.colors.cyan )
fg_bg("AvanteReversedTitle",      vim.g.colors.cyan,  vim.g.colors.bg   )
fg_bg("AvanteSubtitle",           vim.g.colors.bg,    vim.g.colors.blue )
fg_bg("AvanteReversedSubtitle",   vim.g.colors.blue,  vim.g.colors.bg   )
fg_bg("AvanteThirdTitle",         vim.g.colors.grey2, vim.g.colors.grey1)
fg_bg("AvanteReversedThirdTitle", vim.g.colors.grey1, vim.g.colors.bg   )

------------------
--  STATUS BAR  --
------------------

-- require("plugins.statusline").config()
require("plugins.lualine").config()

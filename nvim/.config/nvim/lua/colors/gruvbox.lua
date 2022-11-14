local M = {}

M.config = function ()
    local utils   = require("utils")
    local palette = require("gruvbox.palette");
    local bg      = palette.dark0_hard;

    -- setup must be called before loading the colorscheme
    -- Default options:
    require("gruvbox").setup({
        undercurl            = true,
        underline            = true,
        bold                 = true,
        italic               = true,
        strikethrough        = true,
        invert_selection     = false,
        invert_signs         = false,
        invert_tabline       = false,
        invert_intend_guides = false,
        inverse              = true, -- invert background for search, diffs, statuslines and errors
        contrast             = "hard", -- can be "hard", "soft" or empty string
        overrides            = {
            -- mini.jump2d jump spots
            MiniJump2dSpot = {fg = "",
                        bg = bg,
                        reverse = true},
            -- Popup (lsp_signature)
            NormalFloat = {fg = "",
                        bg = bg,
                        reverse = false},
            -- Signature Popup (current parameter)
            LspSignatureActiveParameter = {fg = palette.bright_purple,
                                           bg = bg},
            -- Lines that were added
            DiffAdd     = {fg = "",
                        bg = utils.colors.darken(palette.faded_blue, 0.15, bg),
                        reverse = false},
            -- Lines that were added
            DiffAdded   = {fg = "",
                        bg = utils.colors.darken(palette.faded_blue, 0.15, bg),
                        reverse = false},
            DiffNewFile = {fg = palette.neutral_green,
                        bg = utils.colors.darken(palette.faded_blue, 0.15, bg),
                        reverse = false},

            -- Differing lines
            DiffChange  = {fg = "",
                        bg = utils.colors.darken(palette.faded_blue, 0.15, bg),
                        reverse = false},
            -- Text that differs on changed lines
            DiffText    = {fg = "",
                        bg = utils.colors.darken(palette.faded_blue, 0.4, bg),
                        reverse = false},

            -- Lines that were deleted
            DiffDelete  = {fg = palette.neutral_red,
                        bg = utils.colors.darken(palette.faded_red, 0.2, bg),
                        reverse = false},
            -- Lines that were deleted
            DiffRemoved = {fg = palette.neutral_red,
                        bg = utils.colors.darken(palette.faded_red, 0.2, bg),
                        reverse = false},

            -- File diffs
            DiffFile    = {fg = "",
                        bg = utils.colors.darken(palette.neutral_orange, 0.4, bg),
                        reverse = false},
            -- Lines that are diffed in diff
            DiffLine    = {fg = "",
                        bg = utils.colors.darken(palette.neutral_aqua,   0.4, bg),
                        reverse = false},

            -- Sign column (left of numbers)
            SignColumn  = {bg = bg},

            -- Sign column '+' symbol
            GitSignsAddNr    = {bg = bg, fg = palette.bright_green},
            -- Sign column '~' symbol
            GitSignsChangeNr = {bg = bg, fg = palette.bright_aqua},
            -- Sign column '-' symbol
            GitSignsDeleteDr = {bg = bg, fg = palette.bright_red},
        },
    })

    vim.cmd("colorscheme gruvbox")
end

return M

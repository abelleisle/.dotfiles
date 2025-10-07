local M = {}

M.config = function(style)
    require("onedark").setup({

        -- Main options --
        style = style, -- Default theme style. Choose between "dark", "darker", "cool", "deep", "warm", "warmer" and "light"
        transparent = false, -- Show/hide background
        term_colors = true, -- Change terminal color as per the selected theme style
        ending_tildes = false, -- Show the end-of-buffer tildes. By default they are hidden
        cmp_itemkind_reverse = false, -- reverse item kind highlights in cmp menu

        -- toggle theme style ---
        toggle_style_key = nil, -- keybind to toggle theme style. Leave it nil to disable it, or set it to a string, for example "<leader>ts"
        toggle_style_list = { "dark", "darker", "cool", "deep", "warm", "warmer", "light" }, -- List of styles to toggle between

        -- Change code style ---
        -- Options are italic, bold, underline, none
        -- You can configure multiple style with comma separated, For e.g., keywords = "italic,bold"
        code_style = {
            comments = "italic",
            keywords = "none",
            functions = "none",
            strings = "none",
            variables = "none",
        },

        -- Lualine options --
        lualine = {
            transparent = false, -- lualine center bar transparency
        },

        -- Override default colors
        colors = {},
        -- Override highlight groups
        highlights = {
            -- Line numbers above current
            LineNrAbove = { fg = "$grey" },
            -- Current line number
            LineNr = { fg = "$yellow", bold = false },
            -- Line numbers below current
            LineNrBelow = { fg = "$grey" },
        },

        -- Plugins Config --
        diagnostics = {
            darker = true, -- darker colors for diagnostic
            undercurl = true, -- use undercurl instead of underline for diagnostics
            background = true, -- use background color for virtual text
        },
    })

    local palette = require("onedark.colors")

    vim.g.colors = {
        bg = palette.bg0,
        fg = palette.fg,
        magenta = palette.purple,
        red = palette.red,
        orange = palette.peach,
        yellow = palette.yellow,
        green = palette.green,
        cyan = palette.cyan,
        blue = palette.blue,
        grey0 = palette.bg3,
        grey1 = palette.grey,
        grey2 = palette.light_grey,
    }

    require("onedark").load()
end

return M
